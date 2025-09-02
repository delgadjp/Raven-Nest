import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  final List<String> tabs;
  final TabController? controller;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      height: 44,
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TabBar(
        controller: controller,
        isScrollable: tabs.length > 3,
        dividerColor: Colors.transparent,
        labelColor: selectedColor ?? const Color(0xFF0F172A),
        unselectedLabelColor: unselectedColor ?? const Color(0xFF64748B),
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.zero,
        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
        tabs: tabs.map((tab) => Tab(
          child: Text(
            tab,
            style: const TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
          ),
        )).toList(),
      ),
    );
  }
}
