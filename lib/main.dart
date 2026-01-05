/// CodeSync Arena - Main Entry Point
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config/app_theme.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/team/team_create_screen.dart';
import 'screens/team/team_join_screen.dart';
import 'screens/battle/team_lobby_screen.dart';
import 'screens/battle/arena_screen.dart';
import 'screens/battle/results_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set to 60 FPS for smooth animations
  Future.delayed(Duration.zero, () {
    // Keep high refresh rate
  });
  
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(
    const ProviderScope(
      child: CodeSyncApp(),
    ),
  );
}

class CodeSyncApp extends StatefulWidget {
  const CodeSyncApp({Key? key}) : super(key: key);

  @override
  State<CodeSyncApp> createState() => _CodeSyncAppState();
}

class _CodeSyncAppState extends State<CodeSyncApp> {
  bool _showSplash = true;

  void _completeSplash() {
    setState(() {
      _showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CodeSync Arena',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: _showSplash
          ? SplashScreen(onComplete: _completeSplash)
          : const HomeScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/team/create':
            return _buildPageRoute(
              builder: (_) => const TeamCreateScreen(),
              settings: settings,
            );
          case '/team/join':
            return _buildPageRoute(
              builder: (_) => const TeamJoinScreen(),
              settings: settings,
            );
          case '/room/lobby':
            final roomId = settings.arguments as String;
            return _buildPageRoute(
              builder: (_) => TeamLobbyScreen(roomId: roomId),
              settings: settings,
            );
          case '/battle/arena':
            final battleId = settings.arguments as String;
            return _buildPageRoute(
              builder: (_) => ArenaScreen(battleId: battleId),
              settings: settings,
            );
          case '/battle/results':
            final battleId = settings.arguments as String;
            return _buildPageRoute(
              builder: (_) => ResultsScreen(battleId: battleId),
              settings: settings,
            );
          default:
            return _buildPageRoute(
              builder: (_) => const HomeScreen(),
              settings: settings,
            );
        }
      },
    );
  }

  PageRoute<T> _buildPageRoute<T>({
    required WidgetBuilder builder,
    required RouteSettings settings,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.98, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            ),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 350),
    );
  }
}
