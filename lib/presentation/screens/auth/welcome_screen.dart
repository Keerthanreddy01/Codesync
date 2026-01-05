/// Welcome/splash screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/auth_widgets.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Logo / Header
            Expanded(
              flex: 2,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo/Icon
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.secondary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.code_rounded,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // App Name
                    Text(
                      'CodeSync Arena',
                      style: AppTextTheme.heading1.copyWith(
                        background: Paint()
                          ..color = AppColors.primary.withOpacity(0.1),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Tagline
                    Text(
                      'Compete. Collaborate. Excel.',
                      style: AppTextTheme.body1.copyWith(
                        color: AppColors.textMuted,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Features
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _FeatureItem(
                          icon: Icons.lightning_bolt_rounded,
                          title: 'Real-Time Battles',
                          description: 'Compete in live coding challenges',
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _FeatureItem(
                          icon: Icons.people_outline,
                          title: 'Team Collaboration',
                          description: 'Work together with built-in tools',
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _FeatureItem(
                          icon: Icons.analytics_outlined,
                          title: 'AI Feedback',
                          description: 'Get insights to improve your code',
                        ),
                      ],
                    ),

                    // Buttons
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            text: 'Get Started',
                            onPressed: () => context.push('/signup'),
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            text: 'Sign In',
                            onPressed: () => context.push('/login'),
                            variant: ButtonVariant.outline,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 24,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextTheme.subheading2,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                description,
                style: AppTextTheme.body2.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
