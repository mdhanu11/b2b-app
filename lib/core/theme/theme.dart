import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muward_b2b/core/constants/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    textTheme: GoogleFonts.interTextTheme(),
    primarySwatch: AppColors.customSwatch,
    brightness: Brightness.light,
  );

  static ThemeData darkTheme = ThemeData(
    textTheme: GoogleFonts.interTextTheme(),
    primarySwatch: AppColors.customSwatch,
    brightness: Brightness.dark,
  );
}
