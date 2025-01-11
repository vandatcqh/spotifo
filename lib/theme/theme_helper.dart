import 'package:flutter/material.dart';
import '../core/app_export.dart';

String _appTheme = "lightCode";
LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();
/// Helper class for managing themes and colors.
// ignore_for_file: must_be_immutable
class ThemeHelper {
// A map of custom color themes supported by the app
  Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors()
  };

// A map of color schemes supported by the app
  Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode': ColorSchemes.lightCodeColorScheme
  };

  /// Changes the app theme to [_newTheme].
  void changeTheme(String _newTheme) {
    _appTheme = _newTheme;
  }

  /// Returns the lightCode colors for the current theme.
  LightCodeColors getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }


  /// Returns the current theme data.
  ThemeData getThemeData() {
    var colorScheme = _supportedColorScheme[_appTheme] ??
        ColorSchemes.lightCodeColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(colorScheme),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: appTheme.lightGreen100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.h),
          ),
          elevation: 0,
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
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
        visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4
        ),
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        space: 1,
        color: appTheme.blueGray800.withOpacity(0.6),
      ),
    );
  }

  /// Returns the lightCode colors for the current theme.
  LightCodeColors themeColor() => getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => getThemeData();
}



/// Class containing the supported text theme styles.

class TextThemes {

  static TextTheme textTheme(ColorScheme colorScheme) =>
      TextTheme(
        bodyLarge: TextStyle(
          color: appTheme.blueGray800,
          fontSize: 16,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: appTheme.blueGray800,
          fontSize: 14,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: appTheme.blueGray800,
          fontSize: 10,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
        ),
        headlineLarge: TextStyle(
          color: appTheme.lightGreen50,
          fontSize: 32,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
        ),
        headlineMedium: TextStyle(
          color: appTheme.blueGray800,
          fontSize: 28,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
        ),
        headlineSmall: TextStyle(
          color: appTheme.blueGray800,
          fontSize: 24,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w700,
        ),
        labelLarge: TextStyle(
          color: appTheme.blueGray800,
          fontSize: 12,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          color: appTheme.blueGray800.withOpacity(0.6),
          fontSize: 11,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
        ),
        titleLarge: TextStyle(
          color: appTheme.blueGray800,
          fontSize: 22,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
        ),
        titleMedium: TextStyle(
          color: appTheme.blueGray800,
          fontSize: 16,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: appTheme.lightGreen50,
          fontSize: 14,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
        ),
      );
}

/// Class containing the supported color schemes.
class ColorSchemes {
  static final lightCodeColorScheme = ColorScheme.light(
    primary: Color(0XFFE88B6C),
    primaryContainer: Color(0XFF8C325F),
    secondaryContainer: Color(0XFF4BBCAF),
    errorContainer: Color(0XFF2967EE),
    onErrorContainer: Color(0XFF8E1629),
    onPrimary: Color(0XFF011C39),
    onPrimaryContainer: Color(0XFF000000),
  );
}



/// class containing custom colors for a lightCode theme.

class LightCodeColors {

// Blue
  Color get blue500 => Color(0XFF348BEF);

// BlueGray
  Color get blueGray1007f => Color(0X7FD9D9D9);

  Color get blueGray800 => Color(0XFF173A5B);

// DeepPurple
  Color get deepPurple700 => Color(0XFF5822BB);

  Color get deepPurple70001 => Color(0XFF5244A3);

  Color get deepPurple800 => Color(0XFF3D31AB);

// Gray
  Color get gray50 => Color(0XFFFFFAF6);

  Color get gray600 => Color(0XFF6A7481);

// Green
  Color get green500 => Color(0XFF57AE5A);

  Color get greenA200 => Color(0XFF45E299);

// Indigo
  Color get indigo300 => Color(0XFF6D76DE);

  Color get indigo30001 => Color(0XFF6E89E4);

  Color get indigo400 => Color(0XFF486DA7);

  Color get indigo500 => Color(0XFF544DB9);

  Color get indigo900 => Color(0XFF0F3468);

// LightGreen
  Color get lightGreen100 => Color(0XFFE7D6C6);

  Color get lightGreen50 => Color(0xFFF6F4E7);

  Color get lightGreenA400 => Color(0XFF78FF18);

// Lime
  Color get lime700 => Color(0XFFC9BCBF);

// Orange
  Color get orange200 => Color(0XFFE4C46E);

  Color get orange20001 => Color(0XFFFFC673);

  Color get orange300 => Color(0XFFFFBB55);

// Pink
  Color get pink400 => Color(0XFFD6409F);

  Color get pink500 => Color(0XFFE52874);

// Purple
  Color get purple500 => Color(0XFFB2308B);

  Color get purpleA100 => Color(0XFFE573E1);

  Color get purpleA10001 => Color(0XFFDE6DDE);


// Red
  Color get red200 => Color(0XFFE78898);

  Color get red20001 => Color(0XFFE7AD95);

  Color get red300 => Color(0XFFB96466);

  Color get red400 => Color(0XFFC44D4F);

  Color get red500 => Color(0XFFFF3C3C);

  Color get red600 => Color(0XFFDD3D3D);

  Color get redA200 => Color(0XFFF75659);

  // Teal
  Color get teal300 => Color(0XFF4ED8AD);

  Color get teal400 => Color(0XFF278585);

  Color get teal900 => Color(0XFF143D5D);

  Color get tealA400 => Color(0XFF2BDD8A);

  // White
  Color get whiteA700 => Color(0XFFFFFFFF);

}
