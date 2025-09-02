import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final AlignmentGeometry? begin;
  final AlignmentGeometry? end;

  const GradientBackground({
    super.key,
    required this.child,
    this.colors,
    this.begin,
    this.end,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin ?? Alignment.topLeft,
            end: end ?? Alignment.bottomRight,
            colors: colors ?? const [
              Color(0xFFF8FAFC),
              Color(0xFFDDEAFF),
              Color(0xFFE0E7FF),
            ],
          ),
        ),
        child: child,
      ),
    );
  }
}
