/// Premium Splash Screen - CodeSync
import 'package:flutter/material.dart';
import 'dart:async';
import '../../widgets/codesync_logo.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const SplashScreen({
    super.key,
    required this.onComplete,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _slideUp;
  late Animation<double> _scaleIn;
  late Animation<double> _loadingBar;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2400),
      vsync: this,
    );

    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _slideUp = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.65, curve: Curves.easeOut),
      ),
    );

    _scaleIn = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
      ),
    );

    _loadingBar = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();

    Timer(const Duration(milliseconds: 3200), () {
      widget.onComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // iOS Status Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '9:41',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    spacing: 3,
                    children: [
                      Icon(Icons.signal_cellular_4_bar,
                          color: Colors.white, size: 9),
                      Icon(Icons.wifi, color: Colors.white, size: 9),
                      Icon(Icons.battery_full, color: Colors.white, size: 9),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Main Content
          Center(
            child: AnimatedBuilder(
              animation: Listenable.merge([_fadeIn, _slideUp, _scaleIn]),
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeIn.value,
                  child: Transform.translate(
                    offset: Offset(0, _slideUp.value),
                    child: Transform.scale(
                      scale: _scaleIn.value,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Top accent line (smaller)
                          Container(
                            width: 40,
                            height: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.white.withOpacity(0.5),
                                  Colors.transparent,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Main Logo
                          CodeSyncLogo(
                            size: 96,
                            color: Colors.white,
                            showText: false,
                          ),
                          const SizedBox(height: 20),

                          // Logo Text
                          ShaderMask(
                            shaderCallback: (bounds) {
                              return LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white,
                                  Colors.white.withOpacity(0.92),
                                ],
                              ).createShader(bounds);
                            },
                            child: Text(
                              'CODESYNC',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2.8,
                                color: Colors.white,
                                height: 1.0,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Bottom accent line (smaller)
                          Container(
                            width: 40,
                            height: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.white.withOpacity(0.5),
                                  Colors.transparent,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Tagline (refined)
                          FadeTransition(
                            opacity: _fadeIn,
                            child: Text(
                              'COMPETITIVE CODING ARENA',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.8,
                                color: Colors.white.withOpacity(0.45),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Loading Progress Bar
                          FadeTransition(
                            opacity: _fadeIn,
                            child: Container(
                              width: 120,
                              height: 2,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(1),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(1),
                                child: LinearProgressIndicator(
                                  value: _loadingBar.value,
                                  backgroundColor: Colors.transparent,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white.withOpacity(0.6),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}




