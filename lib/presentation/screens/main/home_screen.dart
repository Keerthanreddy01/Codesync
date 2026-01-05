/// Home screen placeholder
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../providers/auth_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        title: Text(
          'CodeSync Arena',
          style: AppTextTheme.heading3,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Show menu
            },
          ),
        ],
      ),
      body: authState.when(
        data: (state) {
          if (state.user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not authenticated',
                    style: AppTextTheme.heading2,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ElevatedButton(
                    onPressed: () => context.go('/welcome'),
                    child: const Text('Go to Welcome'),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome, ${state.user!.displayName ?? state.user!.username ?? state.user!.email}!',
                  style: AppTextTheme.heading2,
                ),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Information',
                        style: AppTextTheme.subheading2,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text('Email: ${state.user!.email}'),
                      Text('Username: ${state.user!.username ?? 'Not set'}'),
                      Text('XP: ${state.user!.xp}'),
                      Text('Level: ${state.user!.level}'),
                      Text('Profile Complete: ${state.user!.isProfileComplete}'),
                      Text('Onboarding Complete: ${state.user!.hasCompletedOnboarding}'),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                ElevatedButton(
                  onPressed: () async {
                    await ref.read(signOutProvider.future);
                    if (context.mounted) {
                      context.go('/welcome');
                    }
                  },
                  child: const Text('Sign Out'),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error: $error',
                style: AppTextTheme.body2.copyWith(color: AppColors.error),
              ),
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton(
                onPressed: () => context.go('/welcome'),
                child: const Text('Go to Welcome'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
