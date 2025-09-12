

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


String? uId = '';

class AppColors {
   static const primaryBlue = Color(0xFF1E90FF); // Deep Sky Blue
   static const grey = Color(0xFF808080); // Grey
   static const Color primaryGreen = Color(0xFF2E7D32); // dark green
   static const Color accentGreen = Color(0xFF66BB6A);  // light green
   static const Color background = Color(0xFFF5F7F6);
   static const Color cardBackground = Colors.white;
   static const Color textMuted = Color(0xFF707070);
}

class AppSizes {
   static double get fontSizeTitle => 24.sp;
   static double get fontSizeBody => 16.sp;
   static double get padding => 16.w;
}

class AppAssets {
   static const String logo = 'assets/logo.png'; // Path to logo asset
}