import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/widgets/app_loader.dart';
import '../../../../common/widgets/app_snackbar.dart';
import '../../../../common/widgets/foodify_app_bar.dart';
import '../../../../core/di/injection_container.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/home_feed_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (_) => getIt<HomeCubit>()..loadHome(),
      child: Scaffold(
        appBar: const FoodifyAppBar.home(),
        backgroundColor: Colors.white,
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

            return HomeFeedView(
              onRecipeActionPressed: () {
                AppSnackbar.show(context, 'Recipe card action');
              },
            );
          },
        ),
      ),
    );
  }
}
