import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "npm:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

const SUPPORTED_LOCALES = ["uz", "en", "ru"] as const;
type Locale = (typeof SUPPORTED_LOCALES)[number];

const LOCALE_NAMES: Record<Locale, string> = {
  uz: "Uzbek",
  en: "English",
  ru: "Russian",
};

const GEMINI_MODEL = "gemini-2.5-flash";
const GEMINI_ENDPOINT =
  `https://generativelanguage.googleapis.com/v1beta/models/${GEMINI_MODEL}:generateContent`;

const RESPONSE_SCHEMA = {
  type: "object",
  properties: {
    health_score: { type: "integer", minimum: 0, maximum: 100 },
    health_summary: { type: "string" },
    nutrition_per_serving: {
      type: "object",
      properties: {
        kcal: { type: "number" },
        protein_g: { type: "number" },
        carbs_g: { type: "number" },
        fat_g: { type: "number" },
      },
      required: ["kcal", "protein_g", "carbs_g", "fat_g"],
    },
    disclaimer: { type: "string" },
  },
  required: [
    "health_score",
    "health_summary",
    "nutrition_per_serving",
    "disclaimer",
  ],
};

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (req.method !== "POST") {
    return json({ error: "Method not allowed" }, 405);
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
  const anonKey = Deno.env.get("SUPABASE_ANON_KEY") ?? "";
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
  const geminiKey = Deno.env.get("GEMINI_API_KEY") ?? "";

  if (!supabaseUrl || !anonKey || !serviceRoleKey || !geminiKey) {
    return json({ error: "Function is not configured" }, 500);
  }

  const authHeader = req.headers.get("Authorization") ?? "";
  const token = authHeader.replace(/^Bearer\s+/i, "").trim();
  if (!token) {
    return json({ error: "Authorization bearer token is required" }, 401);
  }

  const userClient = createClient(supabaseUrl, anonKey, {
    global: { headers: { Authorization: `Bearer ${token}` } },
  });

  const {
    data: { user },
    error: userError,
  } = await userClient.auth.getUser(token);

  if (userError || !user) {
    return json({ error: "Invalid or expired session" }, 401);
  }

  let body: { recipe_id?: string; locale?: string };
  try {
    body = await req.json();
  } catch {
    return json({ error: "Invalid JSON body" }, 400);
  }

  const recipeId = (body.recipe_id ?? "").trim();
  const localeInput = (body.locale ?? "").trim().toLowerCase();
  if (!recipeId) {
    return json({ error: "recipe_id is required" }, 400);
  }
  if (!isSupportedLocale(localeInput)) {
    return json({ error: "locale must be one of uz, en, ru" }, 400);
  }
  const locale = localeInput;

  const adminClient = createClient(supabaseUrl, serviceRoleKey);

  const recipe = await loadRecipe(adminClient, recipeId);
  if (!recipe.ok) {
    return json({ error: recipe.error }, recipe.status);
  }

  const canonical = buildCanonicalText(recipe.value);
  const inputHash = await sha256Hex(`${canonical}\n::locale=${locale}\n::model=${GEMINI_MODEL}`);

  const cached = await readCache(adminClient, recipeId, locale, inputHash);
  if (cached) {
    return json({ analysis: cached, cached: true }, 200);
  }

  const prompt = buildPrompt(recipe.value, locale);
  const geminiResult = await callGemini(prompt, geminiKey);
  if (!geminiResult.ok) {
    return json({ error: geminiResult.error }, 502);
  }

  const validated = validateAnalysis(geminiResult.value);
  if (!validated.ok) {
    return json({ error: validated.error }, 502);
  }

  await writeCache(
    adminClient,
    recipeId,
    locale,
    inputHash,
    GEMINI_MODEL,
    validated.value,
  );

  return json({ analysis: validated.value, cached: false }, 200);
});

type Recipe = {
  id: string;
  title: string;
  description: string | null;
  duration_minutes: number | null;
  difficulty: string | null;
  ingredients: Array<{ position: number; content: string }>;
  instructions: Array<{ step_number: number; content: string }>;
};

type Result<T> =
  | { ok: true; value: T }
  | { ok: false; error: string; status: number };

function isSupportedLocale(value: string): value is Locale {
  return (SUPPORTED_LOCALES as readonly string[]).includes(value);
}

async function loadRecipe(
  admin: ReturnType<typeof createClient>,
  recipeId: string,
): Promise<Result<Recipe>> {
  const { data: recipeRow, error: recipeErr } = await admin
    .from("recipes")
    .select("id, title, description, duration_minutes, difficulty")
    .eq("id", recipeId)
    .maybeSingle();

  if (recipeErr) {
    return { ok: false, error: "Failed to load recipe", status: 500 };
  }
  if (!recipeRow) {
    return { ok: false, error: "Recipe not found", status: 404 };
  }

  const { data: ingredients, error: ingErr } = await admin
    .from("recipe_ingredients")
    .select("position, content")
    .eq("recipe_id", recipeId)
    .order("position", { ascending: true });

  if (ingErr) {
    return { ok: false, error: "Failed to load ingredients", status: 500 };
  }

  const { data: instructions, error: instErr } = await admin
    .from("recipe_instructions")
    .select("step_number, content")
    .eq("recipe_id", recipeId)
    .order("step_number", { ascending: true });

  if (instErr) {
    return { ok: false, error: "Failed to load instructions", status: 500 };
  }

  return {
    ok: true,
    value: {
      id: recipeRow.id,
      title: recipeRow.title,
      description: recipeRow.description,
      duration_minutes: recipeRow.duration_minutes,
      difficulty: recipeRow.difficulty,
      ingredients: ingredients ?? [],
      instructions: instructions ?? [],
    },
  };
}

function buildCanonicalText(recipe: Recipe): string {
  const lines: string[] = [];
  lines.push(`title:${recipe.title.trim()}`);
  lines.push(`description:${(recipe.description ?? "").trim()}`);
  lines.push(`duration:${recipe.duration_minutes ?? ""}`);
  lines.push(`difficulty:${recipe.difficulty ?? ""}`);
  lines.push("ingredients:");
  for (const ing of recipe.ingredients) {
    lines.push(`  ${ing.position}. ${ing.content.trim()}`);
  }
  lines.push("instructions:");
  for (const step of recipe.instructions) {
    lines.push(`  ${step.step_number}. ${step.content.trim()}`);
  }
  return lines.join("\n");
}

function buildPrompt(recipe: Recipe, locale: Locale): string {
  const lang = LOCALE_NAMES[locale];
  const ingredients = recipe.ingredients
    .map((i) => `- ${i.content.trim()}`)
    .join("\n");
  const instructions = recipe.instructions
    .map((s) => `${s.step_number}. ${s.content.trim()}`)
    .join("\n");

  return [
    `You are a nutrition assistant. Respond in ${lang}.`,
    `Analyze the recipe below and produce:`,
    `- health_score: integer 0-100 reflecting overall healthiness for a balanced diet.`,
    `- health_summary: one short sentence in ${lang} explaining the score.`,
    `- nutrition_per_serving: approximate kcal, protein_g, carbs_g, fat_g per serving.`,
    `- disclaimer: short note in ${lang} that values are AI estimates, not medical advice.`,
    ``,
    `Recipe:`,
    `Title: ${recipe.title}`,
    `Description: ${recipe.description ?? ""}`,
    `Duration (minutes): ${recipe.duration_minutes ?? "unknown"}`,
    `Difficulty: ${recipe.difficulty ?? "unknown"}`,
    `Ingredients:`,
    ingredients || "(none provided)",
    `Instructions:`,
    instructions || "(none provided)",
  ].join("\n");
}

async function readCache(
  admin: ReturnType<typeof createClient>,
  recipeId: string,
  locale: Locale,
  inputHash: string,
): Promise<Record<string, unknown> | null> {
  const { data, error } = await admin
    .from("recipe_ai_analyses")
    .select("analysis")
    .eq("recipe_id", recipeId)
    .eq("locale", locale)
    .eq("input_hash", inputHash)
    .maybeSingle();

  if (error || !data) return null;
  return data.analysis as Record<string, unknown>;
}

async function writeCache(
  admin: ReturnType<typeof createClient>,
  recipeId: string,
  locale: Locale,
  inputHash: string,
  model: string,
  analysis: Record<string, unknown>,
): Promise<void> {
  await admin
    .from("recipe_ai_analyses")
    .upsert(
      {
        recipe_id: recipeId,
        locale,
        input_hash: inputHash,
        model,
        analysis,
      },
      { onConflict: "recipe_id,locale,input_hash", ignoreDuplicates: true },
    );
}

async function callGemini(
  prompt: string,
  apiKey: string,
): Promise<Result<Record<string, unknown>>> {
  const url = `${GEMINI_ENDPOINT}?key=${encodeURIComponent(apiKey)}`;
  const requestBody = {
    contents: [{ role: "user", parts: [{ text: prompt }] }],
    generationConfig: {
      responseMimeType: "application/json",
      responseSchema: RESPONSE_SCHEMA,
      temperature: 0.3,
    },
  };

  let resp: Response;
  try {
    resp = await fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(requestBody),
    });
  } catch (e) {
    return { ok: false, error: `Gemini fetch failed: ${e}`, status: 502 };
  }

  if (!resp.ok) {
    const text = await resp.text();
    return {
      ok: false,
      error: `Gemini HTTP ${resp.status}: ${text.slice(0, 200)}`,
      status: 502,
    };
  }

  let payload: {
    candidates?: Array<{
      content?: { parts?: Array<{ text?: string }> };
    }>;
  };
  try {
    payload = await resp.json();
  } catch {
    return { ok: false, error: "Gemini returned invalid JSON envelope", status: 502 };
  }

  const text = payload.candidates?.[0]?.content?.parts?.[0]?.text;
  if (!text) {
    return { ok: false, error: "Gemini response missing text", status: 502 };
  }

  try {
    const parsed = JSON.parse(text);
    return { ok: true, value: parsed };
  } catch {
    return { ok: false, error: "Gemini response not parseable as JSON", status: 502 };
  }
}

function validateAnalysis(
  raw: Record<string, unknown>,
): Result<Record<string, unknown>> {
  const score = raw.health_score;
  const summary = raw.health_summary;
  const disclaimer = raw.disclaimer;
  const nutrition = raw.nutrition_per_serving as
    | Record<string, unknown>
    | undefined;

  if (
    typeof score !== "number" ||
    !Number.isFinite(score) ||
    score < 0 ||
    score > 100
  ) {
    return { ok: false, error: "Invalid health_score", status: 502 };
  }
  if (typeof summary !== "string" || summary.length === 0) {
    return { ok: false, error: "Invalid health_summary", status: 502 };
  }
  if (typeof disclaimer !== "string" || disclaimer.length === 0) {
    return { ok: false, error: "Invalid disclaimer", status: 502 };
  }
  if (!nutrition || typeof nutrition !== "object") {
    return { ok: false, error: "Invalid nutrition_per_serving", status: 502 };
  }
  for (const key of ["kcal", "protein_g", "carbs_g", "fat_g"]) {
    const v = nutrition[key];
    if (typeof v !== "number" || !Number.isFinite(v) || v < 0) {
      return {
        ok: false,
        error: `Invalid nutrition_per_serving.${key}`,
        status: 502,
      };
    }
  }

  return {
    ok: true,
    value: {
      health_score: Math.round(score),
      health_summary: summary,
      nutrition_per_serving: {
        kcal: nutrition.kcal as number,
        protein_g: nutrition.protein_g as number,
        carbs_g: nutrition.carbs_g as number,
        fat_g: nutrition.fat_g as number,
      },
      disclaimer,
    },
  };
}

async function sha256Hex(input: string): Promise<string> {
  const data = new TextEncoder().encode(input);
  const digest = await crypto.subtle.digest("SHA-256", data);
  const bytes = new Uint8Array(digest);
  let out = "";
  for (const b of bytes) {
    out += b.toString(16).padStart(2, "0");
  }
  return out;
}

function json(body: Record<string, unknown>, status: number): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: {
      ...corsHeaders,
      "Content-Type": "application/json",
    },
  });
}
