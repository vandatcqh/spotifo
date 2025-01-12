import 'package:flutter/material.dart';
import '../core/app_export.dart';

String _appTheme = "lightMode";
ColorScheme get colorTheme => ThemeHelper().themeColor();
TextTheme get textTheme => TextThemes.textTheme();
ThemeData get theme => ThemeHelper().themeData();

/// Helper class for managing themes and colors.
// ignore_for_file: must_be_immutable
class ThemeHelper {
// A map of custom color themes supported by the app
  final Map<String, ColorScheme> _supportedCustomColor = {
    'lightMode': ColorSchemes.lightModeScheme,
    'darkMode': ColorSchemes.darkModeScheme,
  };

// A map of color schemes supported by the app
  final Map<String, ColorScheme> _supportedScheme = {
    'lightMode': ColorSchemes.lightModeScheme,
    'darkMode': ColorSchemes.darkModeScheme,
  };

  /// Changes the app theme to [newTheme].
  void changeTheme(String newTheme) {
    _appTheme = newTheme;
  }

  /// Returns the lightCode colors for the current theme.
  ColorScheme getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? ColorSchemes.lightModeScheme;
  }

  /// Returns the current theme data.
  ThemeData getThemeData() {
    var colorScheme =
        _supportedScheme[_appTheme] ?? ColorSchemes.lightModeScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorTheme.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.h)),
          elevation: 0,
          visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
          padding: EdgeInsets.zero,
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        space: 1,
        color: colorTheme.onSurface.withValues(alpha: 0.6),
      ),
    );
  }

  /// Returns the lightCode colors for the current theme.
  ColorScheme themeColor() => getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => getThemeData();
}

/// Class containing the supported text theme styles.
class TextThemes {
  static TextStyle defaultStyle = TextStyle(
    color: Colors.black,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
  );

  static TextTheme textTheme() => TextTheme(
        displayLarge: defaultStyle.copyWith(fontSize: 57, letterSpacing: -0.25),
        displayMedium: defaultStyle.copyWith(fontSize: 45, letterSpacing: 0.0),
        displaySmall: defaultStyle.copyWith(fontSize: 36, letterSpacing: 0.0),
        headlineLarge: defaultStyle.copyWith(fontSize: 32, letterSpacing: 0.0),
        headlineMedium: defaultStyle.copyWith(fontSize: 28, letterSpacing: 0.0),
        headlineSmall: defaultStyle.copyWith(fontSize: 24, letterSpacing: 0.0),
        titleLarge: defaultStyle.copyWith(fontSize: 22, letterSpacing: 0.0),
        titleMedium: defaultStyle.copyWith(fontSize: 16, letterSpacing: 0.15),
        titleSmall: defaultStyle.copyWith(fontSize: 14, letterSpacing: 0.1),
        bodyLarge: defaultStyle.copyWith(fontSize: 16, letterSpacing: 0.5),
        bodyMedium: defaultStyle.copyWith(fontSize: 14, letterSpacing: 0.25),
        bodySmall: defaultStyle.copyWith(fontSize: 12, letterSpacing: 0.4),
        labelLarge: defaultStyle.copyWith(
            fontSize: 14, letterSpacing: 0.1, fontWeight: FontWeight.w500),
        labelMedium: defaultStyle.copyWith(
            fontSize: 12, letterSpacing: 0.5, fontWeight: FontWeight.w500),
        labelSmall: defaultStyle.copyWith(
            fontSize: 11, letterSpacing: 0.5, fontWeight: FontWeight.w500),
      );
}

extension CustomColor on Color {
  Color withAlphaD(double alpha) {
    return withValues(alpha: alpha);
  }
}

extension CustomTextStyle on TextStyle {
  TextStyle withColor(Color color) {
    return copyWith(color: color);
  }

  TextStyle withSize(double size) {
    return copyWith(fontSize: size);
  }

  TextStyle withWeight(FontWeight weight) {
    return copyWith(fontWeight: weight);
  }

  TextStyle withNormal() {
    return copyWith(fontWeight: FontWeight.w400);
  }

  TextStyle withBold() {
    return copyWith(fontWeight: FontWeight.w700);
  }

  TextStyle withFamily(String family) {
    return copyWith(fontFamily: family);
  }

  TextStyle withSpacing(double spacing) {
    return copyWith(letterSpacing: spacing);
  }

  TextStyle withItalic() {
    return copyWith(fontStyle: FontStyle.italic);
  }
}

/// Class containing the supported color schemes.
class ColorSchemes {
  static final lightModeScheme = ColorScheme.light(
    primary: Color(0xFF324A59).withAlphaD(0.0),
    onPrimary: Color(0xFFFFBB55),
    secondary: Color(0xFF143D5D),
    onSecondary: Color(0xFFE7D6C6),
    surface: Color(0xFFF6F4E7),
    onSurface: Color(0xFF173A5B),
    error: Color(0xFFC44D4F),
    onError: Color(0xFFF6F4E7),
  );
  static final darkModeScheme = ColorScheme.dark(
    primary: Color(0xFFE7D6C6),
    onPrimary: Color(0xFF0E3A60),
    secondary: Color(0xFFF6F4E7),
    onSecondary: Color(0xFF173A5B),
    surface: Color(0xFF143D5D),
    onSurface: Color(0xFFF6F4E7),
    error: Color(0xFFC44D4F),
    onError: Color(0xFFF6F4E7),
  );
}
