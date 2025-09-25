import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonLoader extends StatelessWidget {
  final String? message;
  final Color? color;
  final double size;
  final bool showText;

  const CommonLoader({
    super.key,
    this.message,
    this.color,
    this.size = 60,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    final loaderColor = color ?? Theme.of(context).colorScheme.primary;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SpinKitFadingCube(color: loaderColor, size: size),
          if (showText) ...[
            const SizedBox(height: 30),
            Text(
              message ?? "Loading...",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: loaderColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
