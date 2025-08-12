// lib/features/splash/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../gen/assets.gen.dart';

class SplashScreen extends HookConsumerWidget {

  static const route = "/SplashScreen";

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationController = useAnimationController(
      duration: const Duration(seconds: 2),
    )..forward();

    useEffect(() {
      Future.delayed(const Duration(seconds: 3), () {
        context.push('/dashboard');
        // context.navigator.pushReplacementNamed(AddProductPage.route);
      });
      return null;
    }, []);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Center(
          child: FadeTransition(
            opacity: animationController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Assets.images.splashLogo.image(), // your logo here
              ],
            ),
          ),
        ),
      ),
    );
  }
}
