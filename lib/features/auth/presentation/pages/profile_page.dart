import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/foodify_components/foodify_popular_card.dart';
import '../../../../core/di/injection_container.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/profile_cover_header.dart';
import '../widgets/profile_info_section.dart';
import '../widgets/profile_recipe_card.dart';
import '../widgets/profile_stats_bar.dart';
import '../widgets/profile_tab_bar.dart';

// Hardcoded sample data — replace with real data when domain layer is wired.
const _kRecipes = [
  _RecipeData(
    title: 'Frosted pinecone cake',
    chefName: 'Kelly Mayer',
    rating: '4.9',
    cookTime: '30 Min',
    difficulty: 'Medium',
    description:
        'In a large bowl, mix together flour, baking powder, sugar, and salt..',
    placeholderColor: Color(0xFF4A4A4A),
  ),
  _RecipeData(
    title: 'Classic Victoria sandwich recip...',
    chefName: 'Rick Dolynsky',
    rating: '4.4',
    cookTime: '120 Min',
    difficulty: 'Simple',
    description:
        'In a large bowl, mix together flour, baking powder, sugar, and salt..',
    placeholderColor: Color(0xFF5A3A2A),
  ),
  _RecipeData(
    title: 'Pea and Ricotta Omelets',
    chefName: 'Dave Robert',
    rating: '5.0',
    cookTime: '15 Min',
    difficulty: 'Hard',
    description:
        'In a large bowl, mix together flour, baking powder, sugar, and salt..',
    placeholderColor: Color(0xFF2A4A3A),
  ),
];

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // 0 = 18 Post, 1 = Less Details, 2 = More Details
  int _tabIndex = 1;

  bool get _isMoreDetails => _tabIndex == 2;

  @override
  Widget build(BuildContext context) {
    if (!getIt.isRegistered<AuthCubit>()) {
      return const Scaffold(body: Center(child: Text('Auth module is disabled')));
    }

    return BlocProvider<AuthCubit>(
      create: (_) => getIt<AuthCubit>()..checkAuthStatus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: SizedBox(height: 24.h)),
            if (_isMoreDetails)
              _buildMoreDetailsSliver()
            else
              _buildLessDetailsSliver(),
            // Bottom padding so content clears the nav bar
            SliverToBoxAdapter(
              child: SizedBox(height: MediaQuery.paddingOf(context).bottom + 93.h),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Header — cover + stats bar + avatar + info + tabs
  // All child positions derived from 360×800 Figma baseline.
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return SizedBox(
      // Tab bar bottom (363 + 29) = 392. Remaining 24 gap is added as SliverToBoxAdapter above.
      height: 392.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 1. Cover (0 → 128)
          const Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: ProfileCoverHeader(),
          ),

          // 2. Stats bar (left:6, top:132, 348×48)
          Positioned(
            left: 6.w,
            top: 132.h,
            child: const ProfileStatsBar(followers: '357K', following: '24'),
          ),

          // 3. Avatar (centered, top:90, 90×90, 4px white border)
          Positioned(
            top: 90.h,
            left: 0,
            right: 0,
            child: Center(child: _ProfileAvatar()),
          ),

          // 4. "+" add-pic button — sits at bottom-right of avatar
          // Design: left=calc(50%+9px), top=166 → 9px right of screen center
          Positioned(
            top: 166.h,
            left: 189.w, // 180 (center) + 9
            child: const _AddPicButton(),
          ),

          // 5. Name + location + bio + optional Edit Profile btn
          // Name center is at y=213 on Figma. Positioned top ≈ 198 to center correctly.
          Positioned(
            left: 0,
            right: 0,
            top: 198.h,
            child: ProfileInfoSection(showEditButton: _isMoreDetails),
          ),

          // 6. Tab bar (left:6, top:363)
          Positioned(
            left: 6.w,
            top: 363.h,
            child: ProfileTabBar(
              selectedIndex: _tabIndex,
              onTabChanged: (i) => setState(() => _tabIndex = i),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Tab content slivers
  // ──────────────────────────────────────────────────────────────────────────

  // "Less Details" / "18 Post" — 2-column grid of FoodifyPopularCard
  Widget _buildLessDetailsSliver() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      sliver: SliverGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 8.h,
        crossAxisSpacing: 8.w,
        childAspectRatio: 156 / 199,
        children: const [
          FoodifyPopularCard(title: 'chocolate cake with buttercream frosting'),
          FoodifyPopularCard(title: 'chocolate cake with buttercream frosting'),
          FoodifyPopularCard(title: 'chocolate cake with buttercream frosting'),
          FoodifyPopularCard(title: 'chocolate cake with buttercream frosting'),
          FoodifyPopularCard(title: 'chocolate cake with buttercream frosting'),
          FoodifyPopularCard(title: 'chocolate cake with buttercream frosting'),
        ],
      ),
    );
  }

  // "More Details" — vertical list of detailed recipe cards
  Widget _buildMoreDetailsSliver() {
    return SliverPadding(
      padding: EdgeInsets.only(left: 20.w),
      sliver: SliverList.separated(
        itemCount: _kRecipes.length,
        separatorBuilder: (_, _) => SizedBox(height: 12.h),
        itemBuilder: (_, i) {
          final r = _kRecipes[i];
          return ProfileRecipeCard(
            title: r.title,
            chefName: r.chefName,
            rating: r.rating,
            cookTime: r.cookTime,
            difficulty: r.difficulty,
            description: r.description,
            imagePlaceholderColor: r.placeholderColor,
          );
        },
      ),
    );
  }
}

// ─── Small private widgets ──────────────────────────────────────────────────

class _ProfileAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.r,
      height: 90.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4.r),
        color: const Color(0xFF9E9E9E),
      ),
      child: ClipOval(
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            // Placeholder avatar — replace with NetworkImage when user has avatar URL
            return const ColoredBox(color: Color(0xFF9E9E9E));
          },
        ),
      ),
    );
  }
}

class _AddPicButton extends StatelessWidget {
  const _AddPicButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28.r,
      height: 28.r,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.add_circle, color: const Color(0xFF4058A0), size: 24.r),
    );
  }
}

// ─── Hardcoded recipe data ──────────────────────────────────────────────────

class _RecipeData {
  const _RecipeData({
    required this.title,
    required this.chefName,
    required this.rating,
    required this.cookTime,
    required this.difficulty,
    required this.description,
    required this.placeholderColor,
  });

  final String title;
  final String chefName;
  final String rating;
  final String cookTime;
  final String difficulty;
  final String description;
  final Color placeholderColor;
}
