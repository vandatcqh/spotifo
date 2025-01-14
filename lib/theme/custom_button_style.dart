
import 'package:flutter/material.dart';
import '../core/app_export.dart';

class CustomButtonStyles {
// Filled button style
  static ButtonStyle get fillPrimary =>
      ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.h),
        ),
        elevation: 0,
        padding: EdgeInsets.zero,
      );

// Outline button style
  static ButtonStyle get outline =>
      ElevatedButton.styleFrom(
        backgroundColor: colorTheme.surface.withAlphaD(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.h),
        ),
        elevation: 0,
        padding: EdgeInsets.zero,
      );

// text button style
  static ButtonStyle get none =>
      ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
          elevation: WidgetStateProperty.all<double>(0),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
          side: WidgetStateProperty.all<BorderSide>(
            BorderSide(color: Colors.transparent),
          ));

}