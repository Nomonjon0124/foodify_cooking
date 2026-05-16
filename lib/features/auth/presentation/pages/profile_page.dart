import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/app_loader.dart';
import '../../../../common/widgets/foodify_image.dart';
import '../../../../common/widgets/foodify_components/foodify_popular_card.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/profile_view.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/profile_cover_header.dart';
import '../widgets/profile_info_section.dart';
import '../widgets/profile_recipe_card.dart';
import '../widgets/profile_stats_bar.dart';
import '../widgets/profile_tab_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _tabIndex = 1;

  bool get _isMoreDetails => _tabIndex == 2;

  @override
  Widget build(BuildContext context) {
    if (!getIt.isRegistered<ProfileCubit>()) {
      return const Scaffold(
        body: Center(child: Text('Profile module is disabled')),
      );
    }

    return BlocProvider<ProfileCubit>(
      create: (_) => getIt<ProfileCubit>()..loadProfile(),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final profile = state.profile;

          if (state.status == ProfileStatus.failure) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Text(state.errorMessage ?? 'Failed to load profile'),
              ),
            );
          }

          if (state.status == ProfileStatus.loading || profile == null) {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: AppLoader(),
            );
          }

          return Scaffold(
            backgroundColor: Colors.white,
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader(profile)),
                SliverToBoxAdapter(child: SizedBox(height: 24.h)),
                if (_isMoreDetails)
                  _buildMoreDetailsSliver(profile.recipes)
                else
                  _buildLessDetailsSliver(profile.recipes),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.paddingOf(context).bottom + 93.h,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(ProfileView profile) {
    return SizedBox(
      height: 392.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: ProfileCoverHeader(
              coverImageUrl: profile.coverImageUrl,
              rating: profile.ratingLabel,
            ),
          ),
          Positioned(
            left: 6.w,
            top: 132.h,
            child: ProfileStatsBar(
              followers: profile.followersLabel,
              following: profile.followingLabel,
            ),
          ),
          Positioned(
            top: 90.h,
            left: 0,
            right: 0,
            child: Center(child: _ProfileAvatar(imageUrl: profile.avatarUrl)),
          ),
          Positioned(top: 166.h, left: 189.w, child: const _AddPicButton()),
          Positioned(
            left: 0,
            right: 0,
            top: 198.h,
            child: ProfileInfoSection(
              name: profile.displayName,
              location: profile.location,
              bio: profile.bio,
              showEditButton: _isMoreDetails,
            ),
          ),
          Positioned(
            left: 6.w,
            top: 363.h,
            child: ProfileTabBar(
              selectedIndex: _tabIndex,
              postsCount: profile.postsCount,
              onTabChanged: (i) => setState(() => _tabIndex = i),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessDetailsSliver(List<ProfileRecipe> recipes) {
    if (recipes.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: Text('No profile recipes found')),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          final recipe = recipes[index];
          return FoodifyPopularCard(
            title: recipe.title,
            rating: recipe.ratingLabel,
            imagePath: FoodifyImage(recipe.imageUrl, fit: BoxFit.cover),
          );
        }, childCount: recipes.length),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.h,
          crossAxisSpacing: 8.w,
          childAspectRatio: 156 / 199,
        ),
      ),
    );
  }

  Widget _buildMoreDetailsSliver(List<ProfileRecipe> recipes) {
    if (recipes.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: Text('No profile recipes found')),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.only(left: 20.w),
      sliver: SliverList.separated(
        itemCount: recipes.length,
        separatorBuilder: (_, _) => SizedBox(height: 12.h),
        itemBuilder: (_, index) {
          final recipe = recipes[index];
          return ProfileRecipeCard(
            title: recipe.title,
            chefName: recipe.chefName,
            rating: recipe.ratingLabel,
            cookTime: recipe.durationLabel,
            difficulty: recipe.difficultyLabel,
            description: recipe.description,
            imageUrl: recipe.imageUrl,
            chefAvatarUrl: recipe.chefAvatarUrl,
          );
        },
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.imageUrl});

  final String imageUrl;

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
        child: imageUrl.isEmpty
            ? const ColoredBox(color: Color(0xFF9E9E9E))
            : FoodifyImage(imageUrl, fit: BoxFit.cover),
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
