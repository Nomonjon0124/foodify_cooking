import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/widgets/app_loader.dart';
import '../../../../common/widgets/app_snackbar.dart';
import '../../../../core/di/injection_container.dart';
import '../cubit/recipe_cubit.dart';
import '../cubit/recipe_state.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RecipeCubit>(
      create: (_) => getIt<RecipeCubit>()..loadRecipes(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Recipes')),
        body: BlocConsumer<RecipeCubit, RecipeState>(
          listener: (context, state) {
            if (state.status == RecipeStatus.failure) {
              AppSnackbar.show(
                context,
                state.errorMessage ?? 'Unable to load recipes',
              );
            }
          },
          builder: (context, state) {
            if (state.status == RecipeStatus.loading) {
              return const AppLoader();
            }

            if (state.recipes.isEmpty) {
              return const Center(child: Text('No recipes found'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.recipes.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(state.recipes[index]),
                    subtitle: const Text('TODO: Open recipe details'),
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
