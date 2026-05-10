import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeritageColors {
  static const background = Color(0xFF131407);
  static const surface = Color(0xFF1F2111);
  static const surfaceHigh = Color(0xFF2A2B1B);
  static const surfaceLow = Color(0xFF1B1D0E);
  static const primary = Color(0xFFF2CA50);
  static const primaryContainer = Color(0xFFD4AF37);
  static const onPrimary = Color(0xFF3C2F00);
  static const accent = Color(0xFF920703);
  static const accentLight = Color(0xFFFFB4A8);
  static const olive = Color(0xFFBED890);
  static const onSurface = Color(0xFFE4E4CC);
  static const onSurfaceVariant = Color(0xFFD0C5AF);
  static const outline = Color(0xFF99907C);
  static const outlineVariant = Color(0xFF4D4635);
}

class HeritageTheme {
  static ThemeData dark(String locale) {
    final isArabic = locale == 'ar';
    final baseTextTheme = isArabic
        ? GoogleFonts.amiriTextTheme(ThemeData.dark().textTheme)
        : GoogleFonts.playfairDisplayTextTheme(ThemeData.dark().textTheme);

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: HeritageColors.background,
      colorScheme: const ColorScheme.dark(
        primary: HeritageColors.primary,
        primaryContainer: HeritageColors.primaryContainer,
        onPrimary: HeritageColors.onPrimary,
        secondary: HeritageColors.accentLight,
        secondaryContainer: HeritageColors.accent,
        tertiary: HeritageColors.olive,
        surface: HeritageColors.surface,
        onSurface: HeritageColors.onSurface,
        onSurfaceVariant: HeritageColors.onSurfaceVariant,
        outline: HeritageColors.outline,
        outlineVariant: HeritageColors.outlineVariant,
      ),
      textTheme: baseTextTheme.apply(
        bodyColor: HeritageColors.onSurface,
        displayColor: HeritageColors.onSurface,
      ),
      useMaterial3: true,
    );
  }

  static TextStyle displayHero(BuildContext context, {double vhFactor = 0.06}) {
    final h = MediaQuery.of(context).size.height;
    return GoogleFonts.playfairDisplay(
      fontSize: h * vhFactor,
      fontWeight: FontWeight.w700,
      color: HeritageColors.primary,
      height: 1.1,
      shadows: [
        const Shadow(
          color: Color(0x99D4AF37),
          blurRadius: 20,
        ),
      ],
    );
  }

  static TextStyle headlineLg(BuildContext context, {double vhFactor = 0.035}) {
    final h = MediaQuery.of(context).size.height;
    return GoogleFonts.playfairDisplay(
      fontSize: h * vhFactor,
      fontWeight: FontWeight.w600,
      color: HeritageColors.onSurface,
      height: 1.2,
    );
  }

  static TextStyle headlineMd(BuildContext context, {double vhFactor = 0.025}) {
    final h = MediaQuery.of(context).size.height;
    return GoogleFonts.playfairDisplay(
      fontSize: h * vhFactor,
      fontWeight: FontWeight.w500,
      color: HeritageColors.onSurface,
      height: 1.3,
    );
  }

  static TextStyle body(BuildContext context, {double vhFactor = 0.018}) {
    final h = MediaQuery.of(context).size.height;
    return GoogleFonts.montserrat(
      fontSize: h * vhFactor,
      fontWeight: FontWeight.w400,
      color: HeritageColors.onSurfaceVariant,
      height: 1.6,
    );
  }

  static TextStyle labelCaps(BuildContext context, {double vhFactor = 0.013}) {
    final h = MediaQuery.of(context).size.height;
    return GoogleFonts.montserrat(
      fontSize: h * vhFactor,
      fontWeight: FontWeight.w700,
      color: HeritageColors.primaryContainer,
      letterSpacing: 2.0,
    );
  }

  static BoxDecoration glassDecoration({Color? borderColor, double radius = 12}) {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.05),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: borderColor ?? HeritageColors.primaryContainer.withOpacity(0.2),
      ),
    );
  }

  static BoxDecoration goldGlowDecoration() {
    return BoxDecoration(
      color: HeritageColors.primaryContainer,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: HeritageColors.primaryContainer.withOpacity(0.4),
          blurRadius: 30,
          spreadRadius: 2,
        ),
      ],
    );
  }
}
