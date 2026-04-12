import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/app_loader.dart';
import '../../../../common/widgets/app_snackbar.dart';
import '../../../../common/widgets/recipe_cards/recipe_main_card.dart';
import '../../../../core/di/injection_container.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (_) => getIt<HomeCubit>()..loadHome(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Foodify Home')),
        body: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state.status == HomeStatus.failure) {
              AppSnackbar.show(
                context,
                state.errorMessage ?? 'Unable to load data',
              );
            }
          },
          builder: (context, state) {
            if (state.status == HomeStatus.loading) {
              return const AppLoader();
            }

            // TODO: Replace static Figma sample with real recipe data.
            final demoCard = RecipeMainCard(
              title: 'Muffin with Blue Cream',
              authorName: 'Kelly Mayer',
              description:
                  'In a large bowl, mix together flour, baking powder, sugar, and salt..',
              durationLabel: '30 Min',
              difficultyLabel: 'Simple',
              imagePath: 'assets/images/recipe_cards/main_card_content.png',
              authorImagePath: 'assets/images/recipe_cards/user_pic.png',
              topRating: '4.8',
              authorRating: '4.9',
              onActionPressed: () {
                AppSnackbar.show(context, 'Recipe card action');
              },
            );

            if (state.collections.isEmpty) {
              return ListView(
                padding: EdgeInsets.all(16.r),
                children: [
                  Center(child: demoCard),
                  SizedBox(height: 12.h),
                  const Center(child: Text('No featured collections yet')),
                ],
              );
            }

            return ListView.separated(
              padding: EdgeInsets.all(16.r),
              itemCount: state.collections.length + 1,
              separatorBuilder: (_, _) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Center(child: demoCard);
                }

                final collection = state.collections[index - 1];
                return Card(
                  child: ListTile(
                    title: Text(collection),
                    subtitle: const Text('TODO: Open collection details'),
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
