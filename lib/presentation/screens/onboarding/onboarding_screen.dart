/// Onboarding tutorial screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/auth_widgets.dart';
import '../providers/auth_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;

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

  void _handleCompleteOnboarding() async {
    final user = ref.read(authStateProvider).maybeWhen(
      data: (state) => state.user,
      orElse: () => null,
    );

    if (user != null) {
      try {
        await ref.read(markOnboardingCompleteProvider(user.id).future);
        if (mounted) {
          context.go('/home');
        }
      } catch (e) {
        // Handle error silently and navigate anyway
        if (mounted) {
          context.go('/home');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const onboardingPages = [
      OnboardingPage(
        icon: Icons.lightning_bolt_rounded,
        iconColor: Color(0xFFF59E0B),
        title: 'Compete in Real-Time',
        description:
            'Join live coding battles with developers from around the world. Solve challenging problems in a fast-paced competitive environment.',
      ),
      OnboardingPage(
        icon: Icons.people_outline,
        iconColor: Color(0xFF10B981),
        title: 'Team Up & Collaborate',
        description:
            'Form teams with other developers and work together using our Git-style branching system. Communicate with voice and text chat.',
      ),
      OnboardingPage(
        icon: Icons.analytics_outlined,
        iconColor: Color(0xFF3B82F6),
        title: 'Get AI Feedback',
        description:
            'Our advanced AI judge analyzes your code for efficiency, quality, and best practices. Improve your skills with detailed feedback.',
      ),
      OnboardingPage(
        icon: Icons.star_outline,
        iconColor: Color(0xFFEC4899),
        title: 'Earn Achievements',
        description:
            'Unlock badges, earn XP, and climb the global leaderboard. Compete for prestigious titles and seasonal rewards.',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Close Button
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    GestureDetector(
                      onTap: () {
                        _pageController.previousPage(
                          duration: AppDurations.medium,
                          curve: AppCurves.easeInOut,
                        );
                      },
                      child: const Icon(Icons.arrow_back),
                    )
                  else
                    const SizedBox(width: 40),
                  Text(
                    'CodeSync Arena',
                    style: AppTextTheme.heading3.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_currentPage == onboardingPages.length - 1) {
                        _handleCompleteOnboarding();
                      } else {
                        _pageController.jumpToPage(onboardingPages.length - 1);
                      }
                    },
                    child: Text(
                      _currentPage == onboardingPages.length - 1 ? 'Done' : 'Skip',
                      style: AppTextTheme.body2.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() => _currentPage = page);
                },
                itemCount: onboardingPages.length,
                itemBuilder: (context, index) {
                  return OnboardingPageView(
                    page: onboardingPages[index],
                  );
                },
              ),
            ),

            // Page Indicator & Button
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                children: [
                  // Indicator
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: onboardingPages.length,
                    effect: const ExpandingDotsEffect(
                      dotColor: AppColors.border,
                      activeDotColor: AppColors.primary,
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 4,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Next/Done Button
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: _currentPage == onboardingPages.length - 1
                          ? 'Start Competing'
                          : 'Next',
                      onPressed: () {
                        if (_currentPage == onboardingPages.length - 1) {
                          _handleCompleteOnboarding();
                        } else {
                          _pageController.nextPage(
                            duration: AppDurations.medium,
                            curve: AppCurves.easeInOut,
                          );
                        }
                      },
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Single onboarding page
class OnboardingPage {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;

  const OnboardingPage({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });
}

/// Onboarding page view
class OnboardingPageView extends StatelessWidget {
  final OnboardingPage page;

  const OnboardingPageView({
    Key? key,
    required this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Container
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: page.iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                page.icon,
                size: 60,
                color: page.iconColor,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Title
          Text(
            page.title,
            style: AppTextTheme.heading2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Description
          Text(
            page.description,
            style: AppTextTheme.body1.copyWith(
              color: AppColors.textMuted,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
