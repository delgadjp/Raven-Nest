import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final double elevation;
  final List<BoxShadow>? boxShadow;
  final Border? border;

  const ReusableCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 12,
    this.backgroundColor,
    this.elevation = 0,
    this.boxShadow,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
        boxShadow: boxShadow ?? (elevation > 0 ? [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: elevation * 2,
            offset: Offset(0, elevation),
          ),
        ] : null),
      ),
      child: padding != null 
        ? Padding(padding: padding!, child: child)
        : child,
    );
  }
}
