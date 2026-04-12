import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../core/di/injection_container.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!getIt.isRegistered<AuthCubit>()) {
      return const Scaffold(
        body: Center(child: Text('Auth module is disabled')),
      );
    }

    return BlocProvider<AuthCubit>(
      create: (_) => getIt<AuthCubit>()..checkAuthStatus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          actions: [
            IconButton(
              onPressed: () async {
                await context.read<AuthCubit>().logout();
                if (context.mounted) {
                  context.go(RouteNames.settings);
                }
              },
              icon: Icon(Icons.logout, size: 24.r),
            ),
          ],
        ),
        body: Center(
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state.status == AuthStatus.loading) {
                return const CircularProgressIndicator();
              }
              if (state.user == null) {
                return const Text('Guest mode: no profile loaded');
              }
              return Text('Hello, ${state.user!.name}');
            },
          ),
        ),
      ),
    );
  }
}
