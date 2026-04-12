import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodify_cooking/core/gen/assets.gen.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../core/di/injection_container.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../widgets/onboarding_bottom_panel.dart';
import '../widgets/onboarding_page_content.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController _pageController;

  static final _pages = <_OnboardingPageData>[
    _OnboardingPageData(
      backgroundColor: Color(0xFF4058A0),
      title: 'Your personal guide to be a chef',
      images: [
        Assets.images.onboarding.onboarding11.path,
        Assets.images.onboarding.onboarding12.path,
        Assets.images.onboarding.onboarding13.path,
      ],
    ),
    _OnboardingPageData(
      backgroundColor: Color(0xFFFF6339),
      title: 'Share the Love, Share the Recipe',
      images: [
        Assets.images.onboarding.onboarding21.path,
        Assets.images.onboarding.onboarding22.path,
        Assets.images.onboarding.onboarding23.path,
      ],
    ),
    _OnboardingPageData(
      backgroundColor: Color(0xFFDEE21B),
      title: 'Foodify Your Global Kitchen',
      images: [
        Assets.images.onboarding.onboarding31.path,
        Assets.images.onboarding.onboarding32.path,
        Assets.images.onboarding.onboarding33.path,
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnboardingCubit>(
      create: (_) => getIt<OnboardingCubit>(),
      child: Scaffold(
        body: BlocBuilder<OnboardingCubit, OnboardingState>(
          builder: (context, state) {
            final page = _pages[state.currentIndex];
            final bottomReservedHeight = OnboardingBottomPanel.responsiveHeight(context);

            return Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: context.read<OnboardingCubit>().onPageChanged,
                  itemBuilder: (context, index) {
                    final data = _pages[index];
                    return OnboardingPageContent(
                      backgroundColor: data.backgroundColor,
                      imagePaths: data.images,
                      isActive: index == state.currentIndex,
                      bottomReservedHeight: bottomReservedHeight,
                    );
                  },
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: OnboardingBottomPanel(
                    title: page.title,
                    currentIndex: state.currentIndex,
                    totalPages: state.totalPages,
                    isLastPage: state.isLastPage,
                    pageColor: page.backgroundColor,
                    pageController: _pageController,
                    onCtaPressed: () {
                      context.read<OnboardingCubit>().onCtaPressed(
                        pageController: _pageController,
                        onCompleted: () => context.go(RouteNames.home),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({required this.backgroundColor, required this.title, required this.images});

  final Color backgroundColor;
  final String title;
  final List<String> images;
}
