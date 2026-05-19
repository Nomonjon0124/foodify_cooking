import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "npm:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
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

  if (!supabaseUrl || !anonKey || !serviceRoleKey) {
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
  const adminClient = createClient(supabaseUrl, serviceRoleKey);

  const {
    data: { user },
    error: userError,
  } = await userClient.auth.getUser(token);

  if (userError || !user) {
    return json({ error: "Invalid or expired session" }, 401);
  }

  const { data: profile, error: profileError } = await adminClient
    .from("profiles")
    .select("id")
    .eq("auth_user_id", user.id)
    .maybeSingle();

  if (profileError) {
    return json({ error: "Unable to load profile" }, 500);
  }

  const mediaError = await deleteProfileMedia(adminClient, user.id);
  if (mediaError) {
    return json({ error: "Unable to delete profile media" }, 500);
  }

  if (profile?.id) {
    const cleanupError = await cleanupProfileData(adminClient, user.id, profile.id);
    if (cleanupError) {
      return json({ error: "Unable to anonymize profile" }, 500);
    }
  }

  const { error: deleteUserError } = await adminClient.auth.admin.deleteUser(user.id);
  if (deleteUserError) {
    return json({ error: "Unable to delete auth user" }, 500);
  }

  return json({ deleted: true }, 200);
});

async function cleanupProfileData(
  adminClient: ReturnType<typeof createClient>,
  userId: string,
  profileId: string,
): Promise<unknown | null> {
  const savedResult = await adminClient
    .from("user_saved_recipes")
    .delete()
    .eq("user_id", userId);
  if (savedResult.error) return savedResult.error;

  const followerResult = await adminClient
    .from("profile_follows")
    .delete()
    .eq("follower_profile_id", profileId);
  if (followerResult.error) return followerResult.error;

  const followingResult = await adminClient
    .from("profile_follows")
    .delete()
    .eq("following_profile_id", profileId);
  if (followingResult.error) return followingResult.error;

  const recipeResult = await adminClient
    .from("recipes")
    .update({ author_id: null, is_profile_visible: false })
    .eq("author_id", profileId);
  if (recipeResult.error) return recipeResult.error;

  const profileResult = await adminClient
    .from("profiles")
    .update({
      auth_user_id: null,
      first_name: "Deleted",
      last_name: "User",
      display_name: "Deleted User",
      slug: `deleted-${profileId}`,
      bio: null,
      location: null,
      avatar_url: null,
      cover_image_url: null,
      rating: 0,
      followers_count: 0,
      following_count: 0,
      posts_count: 0,
      is_deleted: true,
      deleted_at: new Date().toISOString(),
    })
    .eq("id", profileId);

  return profileResult.error;
}

async function deleteProfileMedia(
  adminClient: ReturnType<typeof createClient>,
  userId: string,
): Promise<unknown | null> {
  const prefixes = [`${userId}/avatar`, `${userId}/cover`];

  for (const prefix of prefixes) {
    const { data, error } = await adminClient.storage
      .from("profile-media")
      .list(prefix, { limit: 1000 });

    if (error) return error;
    if (!data?.length) continue;

    const paths = data
      .filter((item) => item.name && item.name !== ".emptyFolderPlaceholder")
      .map((item) => `${prefix}/${item.name}`);

    if (!paths.length) continue;

    const { error: removeError } = await adminClient.storage
      .from("profile-media")
      .remove(paths);

    if (removeError) return removeError;
  }

  return null;
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
