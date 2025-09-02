import 'package:flutter/material.dart';

class ResponsiveCardGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final double maxWidth;

  const ResponsiveCardGrid({
    super.key,
    required this.children,
    this.spacing = 24,
    this.runSpacing = 24,
    this.maxWidth = 1200,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: children.map((child) {
            return SizedBox(
              width: constraints.maxWidth >= maxWidth 
                ? (constraints.maxWidth - (spacing * 3)) / 4 // 4 columns with spacing
                : constraints.maxWidth >= 900 
                  ? (constraints.maxWidth - spacing) / 2 // 2 columns with spacing
                  : constraints.maxWidth, // 1 column
              child: child,
            );
          }).toList(),
        );
      },
    );
  }
}
