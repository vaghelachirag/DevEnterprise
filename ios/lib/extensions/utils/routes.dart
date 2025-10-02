import 'dart:io';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../screens/splash/splash_screen.dart';
import '../../screens/dashboard/dashboard_screen.dart';

class AppRoute {
  static Route? onGeneratedRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.route:
        return navigatePushToScreen(SplashScreen(), settings);
      case DashboardScreen.route:
        return navigatePushToScreen(DashboardScreen(), settings);
      default:
        return null;
    }
  }
}

PageRoute navigatePushToScreen(Widget screen, settings) {
  if (Platform.isIOS) {
    return CupertinoPageRoute(builder: (context) => screen, settings: settings);
  } else {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: myTransitionBuilder,
      transitionDuration: const Duration(milliseconds: 300),
      barrierColor: Colors.black12.withOpacity(0.5),
    );
  }
}

Widget myTransitionBuilder(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return CircularRevealTransition(animation: animation, child: child);
}

class CircularRevealTransition extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;

  const CircularRevealTransition({
    super.key,
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ClipPath(
          clipper: CircularRevealClipper(animation.value),
          child: child,
        );
      },
      child: child,
    );
  }
}

class CircularRevealClipper extends CustomClipper<Path> {
  final double radius;

  CircularRevealClipper(this.radius);

  @override
  Path getClip(Size size) {
    final path = Path();
    path.addOval(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2), // Center of the screen
        radius: radius * size.longestSide,
      ),
    );
    return path;
  }

  @override
  bool shouldReclip(CircularRevealClipper oldClipper) {
    return radius != oldClipper.radius;
  }
}
