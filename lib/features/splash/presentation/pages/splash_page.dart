import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodify_cooking/core/gen/assets.gen.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../core/di/injection_container.dart';
import '../cubit/splash_cubit.dart';
import '../cubit/splash_state.dart';
import '../widgets/splash_loading_dots.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashCubit>(
      create: (_) => getIt<SplashCubit>()..start(),
      child: BlocListener<SplashCubit, SplashState>(
        listenWhen: (previous, current) =>
            previous.status != current.status &&
            current.status == SplashStatus.completed,
        listener: (context, state) => context.go(RouteNames.onboarding),
        child: const _SplashView(),
      ),
    );
  }
}

class _SplashView extends StatefulWidget {
  const _SplashView();

  @override
  State<_SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<_SplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _logoController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..forward();
    _fadeAnimation = Tween<double>(begin: 0.2, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutCubic),
    );
    _scaleAnimation = Tween<double>(begin: 0.92, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4058A0),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Assets.icons.foodifySplashLogo.svg(
                  width: 120.r,
                  height: 120.r,
                ),
              ),
            ),
            Gap(35.h),
            const SplashLoadingDots(),
          ],
        ),
      ),
    );
  }
}
