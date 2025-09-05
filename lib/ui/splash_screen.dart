import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/Logo1.png')
            .animate()
            .fadeIn(duration: const Duration(milliseconds: 800))
            .then(delay: const Duration(seconds: 1))
            .fadeOut(onComplete: (controller) => context.go('/categories')),
      ),
    );
  }
}
