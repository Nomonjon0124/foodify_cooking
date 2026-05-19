import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/widgets/app_loader.dart';
import '../../../../common/widgets/app_snackbar.dart';
import '../../../../common/widgets/foodify_app_bar.dart';
import '../../../../config/routes/route_names.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../../../features/auth/presentation/cubit/auth_state.dart';
import '../../../../features/auth/presentation/widgets/auth_required_prompt.dart';
import '../../../../features/save/presentation/cubit/saved_recipes_cubit.dart';
import '../../../../features/save/presentation/cubit/saved_recipes_state.dart';
import '../../../../l10n/l10n_extension.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/home_feed_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = getIt.isRegistered<AuthCubit>()
        ? getIt<AuthCubit>()
        : null;
    final savedCubit = getIt.isRegistered<SavedRecipesCubit>()
        ? getIt<SavedRecipesCubit>()
        : null;

    return BlocProvider<HomeCubit>(
      create: (_) => getIt<HomeCubit>()..loadHome(),
      child: Scaffold(
        appBar: FoodifyAppBar.home(hintText: context.l10n.searchHint),
        backgroundColor: Colors.white,
        body: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state.status == HomeStatus.failure) {
              AppSnackbar.show(
                context,
                state.errorMessage ?? context.l10n.homeLoadFailure,
              );
            }
          },
          builder: (context, state) {
            if (state.status == HomeStatus.loading) {
              return const AppLoader();
            }

            Widget buildFeed({
              required bool isAuthenticated,
              required Set<String> savedRecipeIds,
            }) {
              return HomeFeedView(
                feed: state.feed,
                savedRecipeIds: savedRecipeIds,
                onRecipeActionPressed: (recipe) {
                  if (!isAuthenticated || savedCubit == null) {
                    showAuthRequiredSheet(context, returnTo: RouteNames.home);
                    return;
                  }
                  savedCubit.toggleRecipe(recipe);
                },
              );
            }

            if (authCubit == null || savedCubit == null) {
              return buildFeed(
                isAuthenticated: false,
                savedRecipeIds: const <String>{},
              );
            }

            return BlocBuilder<AuthCubit, AuthState>(
              bloc: authCubit,
              builder: (context, authState) {
                if (authState.isAuthenticated &&
                    savedCubit.state.status == SavedRecipesStatus.initial) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    savedCubit.loadSavedRecipeIds();
                  });
                }

                return BlocBuilder<SavedRecipesCubit, SavedRecipesState>(
                  bloc: savedCubit,
                  builder: (context, savedState) {
                    if (savedState.status == SavedRecipesStatus.failure) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (context.mounted) {
                          AppSnackbar.show(
                            context,
                            savedState.errorMessage ??
                                context.l10n.saveLoadFailure,
                          );
                        }
                      });
                    }

                    return buildFeed(
                      isAuthenticated: authState.isAuthenticated,
                      savedRecipeIds: savedState.savedRecipeIds,
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
