import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/app_loader.dart';
import '../../../../common/widgets/app_snackbar.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../l10n/l10n_extension.dart';
import '../cubit/recipe_cubit.dart';
import '../cubit/recipe_state.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RecipeCubit>(
      create: (_) => getIt<RecipeCubit>()..loadRecipes(),
      child: Scaffold(
        appBar: AppBar(title: Text(context.l10n.recipesTitle)),
        body: BlocConsumer<RecipeCubit, RecipeState>(
          listener: (context, state) {
            if (state.status == RecipeStatus.failure) {
              AppSnackbar.show(
                context,
                state.errorMessage ?? context.l10n.recipesLoadFailure,
              );
            }
          },
          builder: (context, state) {
            if (state.status == RecipeStatus.loading) {
              return const AppLoader();
            }

            if (state.recipes.isEmpty) {
              return Center(child: Text(context.l10n.recipesEmpty));
            }

            return ListView.separated(
              padding: EdgeInsets.all(16.r),
              itemCount: state.recipes.length,
              separatorBuilder: (_, _) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(state.recipes[index]),
                    subtitle: Text(context.l10n.recipeDetailsTodo),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
