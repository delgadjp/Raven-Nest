import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color primaryGreen = Color(0xFF10B981);
  static const Color primaryPurple = Color(0xFF7C3AED);
  static const Color primaryOrange = Color(0xFFEA580C);
  static const Color primaryRed = Color(0xFFDC2626);

  // Gradient Colors
  static const Color gradientStart = Color(0xFFF8FAFC);
  static const Color gradientMiddle = Color(0xFFE0E7FF);
  static const Color gradientEnd = Color(0xFFC7D2FE);

  // Success Colors
  static const Color successGreen = Color(0xFF059669);
  static const Color successGreenLight = Color(0xFF22C55E);

  // Status Colors
  static const Color warningYellow = Color(0xFFF59E0B);
  static const Color criticalRed = Color(0xFFEF4444);

  // Platform Colors
  static const Color airbnbRed = Color(0xFFFF5A5F);
  static const Color bookingBlue = Color(0xFF003580);
  static const Color directGreen = Color(0xFF10B981);
  static const Color otherGray = Color(0xFF6B7280);
}

class AppGradients {
  static const LinearGradient defaultBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.gradientStart,
      AppColors.gradientMiddle,
      AppColors.gradientEnd,
    ],
  );

  static const LinearGradient greenGradient = LinearGradient(
    colors: [AppColors.successGreenLight, AppColors.successGreen],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient blueGradient = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF7C3AED)],
  );

  static const LinearGradient orangeRedGradient = LinearGradient(
    colors: [Color(0xFFF97316), Color(0xFFDC2626)],
  );
}

class AppConstants {
  static const double defaultRadius = 12.0;
  static const double defaultPadding = 16.0;
  static const double cardElevation = 0.0;
  
  static const EdgeInsets defaultMargin = EdgeInsets.all(defaultPadding);
  static const EdgeInsets cardPadding = EdgeInsets.all(12.0);
  
  static const double maxContainerWidth = 1200.0;
  
  // Responsive breakpoints
  static const double mobileBreakpoint = 768.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1200.0;
}
