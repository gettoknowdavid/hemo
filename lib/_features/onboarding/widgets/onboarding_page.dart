import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hemo/_features/onboarding/_models/onboarding_item.dart';
import 'package:hemo/_shared/ui/theme/h_colors.dart';
import 'package:hemo/_shared/ui/theme/h_text_styles.dart';
import 'package:hemo/_shared/ui/ui/buttons/h_primary_button.dart';
import 'package:hemo/_shared/ui/ui/buttons/h_text_button.dart';
import 'package:hemo/routing/routes.dart';

class OnboardingPage extends WatchingStatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      setState(() {
        if (_pageController.page == null) return;
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == onboardingItems.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: .stretch,
          mainAxisSize: .min,
          mainAxisAlignment: .center,
          children: [
            20.verticalSpace,
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16).r,
                child: HTextButton('Skip', onPressed: goToLogin),
              ),
            ),
            const Spacer(),
            _Body(controller: _pageController),
            64.verticalSpace,
            _Indicator(currentPage: _currentPage, onTap: goToPage),
            73.verticalSpace,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20).r,
              child: HPrimaryButton(
                isLastPage ? 'Get Started' : 'Next',
                onPressed: isLastPage ? goToLogin : nextPage,
              ),
            ),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }

  Future<void> nextPage() {
    return _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  Future<void> goToPage(int page) {
    return _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  Future<void> goToLogin() async => context.push(Routes.signIn);
}

class _Body extends StatelessWidget {
  const _Body({required this.controller});

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxHeight: 500.h,
      child: PageView.builder(
        controller: controller,
        itemCount: onboardingItems.length,
        itemBuilder: (context, index) {
          final item = onboardingItems[index];
          return Column(
            mainAxisSize: .min,
            mainAxisAlignment: .center,
            children: [
              Image.asset(item.imagePath, width: 310.w, height: 226.h),
              64.verticalSpace,
              Text(
                item.title,
                style: HTextStyles.headlineBold,
                textAlign: .center,
                maxLines: 1,
              ),
              16.verticalSpace,
              SizedBox(
                width: 295.w,
                child: Text(
                  item.description,
                  style: HTextStyles.bodyMedium.copyWith(letterSpacing: -0.25),
                  textAlign: .center,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  const _Indicator({required this.currentPage, required this.onTap});

  final int currentPage;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96.w,
      height: 16.h,
      child: Row(
        mainAxisAlignment: .center,
        spacing: 16.w,
        children: onboardingItems.map((item) {
          final index = onboardingItems.indexOf(item);
          final isCurrent = currentPage == index;

          return GestureDetector(
            onTap: isCurrent ? null : () => onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              height: 16.h,
              width: isCurrent ? 32.w : 16.w,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(.circular(100)).r,
                color: isCurrent
                    ? HColors.primary
                    : HColors.primary.withValues(alpha: 0.6),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
