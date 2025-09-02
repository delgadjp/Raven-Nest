import 'package:flutter/material.dart';

class ResponsiveChartsLayout extends StatelessWidget {
  final List<Widget> charts;
  final double spacing;
  final double breakpoint;

  const ResponsiveChartsLayout({
    super.key,
    required this.charts,
    this.spacing = 32,
    this.breakpoint = 1024,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use column layout on smaller screens
        if (constraints.maxWidth < breakpoint) {
          return Column(
            children: _buildColumnChildren(),
          );
        }
        // Use row layout on larger screens
        return Row(
          children: _buildRowChildren(),
        );
      },
    );
  }

  List<Widget> _buildColumnChildren() {
    List<Widget> children = [];
    for (int i = 0; i < charts.length; i++) {
      children.add(charts[i]);
      if (i < charts.length - 1) {
        children.add(SizedBox(height: spacing));
      }
    }
    return children;
  }

  List<Widget> _buildRowChildren() {
    List<Widget> children = [];
    for (int i = 0; i < charts.length; i++) {
      children.add(Expanded(child: charts[i]));
      if (i < charts.length - 1) {
        children.add(SizedBox(width: spacing));
      }
    }
    return children;
  }
}
