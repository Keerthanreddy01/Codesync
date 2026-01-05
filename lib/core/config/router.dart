/// Navigation router configuration using GoRouter
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/screens/auth/welcome_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/signup_screen.dart';
import '../../presentation/screens/auth/password_reset_screen.dart';
import '../../presentation/screens/auth/profile_setup_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/main/home_screen.dart';
import '../../presentation/providers/auth_providers.dart';

/// GoRouter configuration
GoRouter createAppRouter(WidgetRef ref) {
  return GoRouter(
    initialLocation: '/welcome',
    routes: [
      // Welcome/Splash
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),

      // Authentication Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),

      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const PasswordResetScreen(),
      ),

      GoRoute(
        path: '/profile-setup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),

      // Onboarding
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Home/Main Routes
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
    redirect: (context, state) {
      // Get auth state
      final authState = ref.watch(authStateProvider);
      final isAuthenticated = authState.maybeWhen(
        data: (state) => state.isAuthenticated,
        orElse: () => false,
      );
      final isProfileComplete = authState.maybeWhen(
        data: (state) => state.user?.isProfileComplete ?? false,
        orElse: () => false,
      );
      final hasCompletedOnboarding = authState.maybeWhen(
        data: (state) => state.user?.hasCompletedOnboarding ?? false,
        orElse: () => false,
      );

      final location = state.matchedLocation;

      // Allow splash/welcome screens to always be accessible
      if (location == '/welcome') {
        if (isAuthenticated && hasCompletedOnboarding) {
          return '/home';
        }
        return null;
      }

      // If not authenticated, redirect to welcome except for specific routes
      if (!isAuthenticated) {
        if (location.startsWith('/login') ||
            location.startsWith('/signup') ||
            location.startsWith('/forgot-password')) {
          return null;
        }
        return '/welcome';
      }

      // If profile not complete, redirect to profile setup
      if (!isProfileComplete && !location.startsWith('/profile-setup')) {
        if (!location.startsWith('/login') &&
            !location.startsWith('/signup') &&
            !location.startsWith('/welcome')) {
          return '/profile-setup';
        }
      }

      // If onboarding not complete, redirect to onboarding
      if (isProfileComplete &&
          !hasCompletedOnboarding &&
          !location.startsWith('/onboarding')) {
        if (!location.startsWith('/login') &&
            !location.startsWith('/signup') &&
            !location.startsWith('/welcome')) {
          return '/onboarding';
        }
      }

      return null;
    },
  );
}

/// Provider for the router
final routerProvider = Provider<GoRouter>((ref) {
  return createAppRouter(ref);
});
