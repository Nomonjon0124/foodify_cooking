import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/app_loader.dart';
import '../../../../common/widgets/app_snackbar.dart';
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

            if (state.collections.isEmpty) {
              return const Center(child: Text('No featured collections yet'));
            }

            return ListView.separated(
              padding: EdgeInsets.all(16.r),
              itemCount: state.collections.length,
              separatorBuilder: (_, _) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(state.collections[index]),
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
