import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/app_loader.dart';
import '../../../../common/widgets/foodify_image.dart';
import '../../../../common/widgets/foodify_components/foodify_popular_card.dart';
import '../../../../config/routes/route_names.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../l10n/l10n_extension.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../auth/presentation/widgets/auth_required_prompt.dart';
import '../cubit/saved_recipes_cubit.dart';
import '../cubit/saved_recipes_state.dart';

class SavePage extends StatelessWidget {
  const SavePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!getIt.isRegistered<AuthCubit>() ||
        !getIt.isRegistered<SavedRecipesCubit>()) {
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.saveTitle)),
        body: Center(child: Text(context.l10n.authModuleDisabled)),
      );
    }

    return BlocBuilder<AuthCubit, AuthState>(
      bloc: getIt<AuthCubit>(),
      builder: (context, authState) {
        if (!authState.isAuthenticated) {
          return Scaffold(
            appBar: AppBar(title: Text(context.l10n.saveTitle)),
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(20.r),
                child: AuthRequiredPrompt(
                  onGooglePressed: () {
                    getIt<AuthCubit>().signInWithGoogle(
                      returnTo: RouteNames.save,
                    );
                  },
                  onEmailPressed: () {
                    context.push(loginRouteForReturnTo(RouteNames.save));
                  },
                ),
              ),
            ),
          );
        }

        final savedCubit = getIt<SavedRecipesCubit>();
        final savedState = savedCubit.state;
        final needsRecipeLoad =
            savedState.status == SavedRecipesStatus.initial ||
            (savedState.status == SavedRecipesStatus.success &&
                savedState.recipes.isEmpty &&
                savedState.savedRecipeIds.isNotEmpty);
        if (needsRecipeLoad) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            savedCubit.loadSavedRecipes();
          });
        }

        return Scaffold(
          appBar: AppBar(title: Text(context.l10n.saveTitle)),
          body: BlocBuilder<SavedRecipesCubit, SavedRecipesState>(
            bloc: savedCubit,
            builder: (context, state) {
              if (state.status == SavedRecipesStatus.loading) {
                return const AppLoader();
              }

              if (state.status == SavedRecipesStatus.failure) {
                return Center(
                  child: Text(
                    state.errorMessage ?? context.l10n.saveLoadFailure,
                  ),
                );
              }

              if (state.recipes.isEmpty) {
                return Center(child: Text(context.l10n.saveEmpty));
              }

              return GridView.builder(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 118.h),
                itemCount: state.recipes.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.h,
                  crossAxisSpacing: 8.w,
                  childAspectRatio: 156 / 199,
                ),
                itemBuilder: (context, index) {
                  final recipe = state.recipes[index];
                  return FoodifyPopularCard(
                    title: recipe.title,
                    rating: recipe.topRatingLabel,
                    imagePath: FoodifyImage(
                      recipe.coverImageUrl,
                      fit: BoxFit.cover,
                    ),
                    state: FoodifyPopularCardState.saved,
                    onSavePressed: () => savedCubit.unsaveRecipe(recipe.id),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
