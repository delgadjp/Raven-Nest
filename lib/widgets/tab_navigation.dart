import 'package:flutter/material.dart';

class TabNavigation extends StatelessWidget {
  final List<String> tabs;
  final int currentTab;
  final Function(int) onTabChanged;
  final Color? backgroundColor;
  final Color? activeColor;
  final Color? inactiveColor;

  const TabNavigation({
    super.key,
    required this.tabs,
    required this.currentTab,
    required this.onTabChanged,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;
          return _tabButton(label, index);
        }).toList(),
      ),
    );
  }

  Widget _tabButton(String label, int index) {
    final isActive = currentTab == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChanged(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isActive 
                  ? (activeColor ?? const Color(0xFF0F172A))
                  : (inactiveColor ?? const Color(0xFF64748B)),
            ),
          ),
        ),
      ),
    );
  }
}
