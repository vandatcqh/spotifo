
import 'package:flutter/material.dart';
import '../core/app_export.dart';

extension on TextStyle {
  TextStyle get poppins {
    return copyWith(
      fontFamily: 'Poppins',
    );
  }
}

class CustomTextStyles {
// Body style

  static get bodyLarge_1 => theme.textTheme.bodyLarge!;

  static TextStyle get bodySmallBlueGray800 =>
      theme.textTheme.bodySmall!.copyWith(
        color: appTheme.blueGray800.withOpacity(0.6),
        fontSize: 12,
      );

  static TextStyle get bodySmallLightGreen50 =>
      theme.textTheme.bodySmall!.copyWith(
        color: appTheme.lightGreen50,
        fontSize: 12,
      );

  static TextStyle get bodySmallTea1900 =>
      theme.textTheme.bodySmall!.copyWith(
        color: appTheme.teal900,
        fontSize: 12,
      );

// Headline text style
  static TextStyle get headlineMediumBold =>
      theme.textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w700,
      );

  static TextStyle get headlineMediumLightGreen50 =>
      theme.textTheme.headlineMedium!.copyWith(color: appTheme.lightGreen50,
      );

  static TextStyle get headlineMediumTea1900 =>
      theme.textTheme.headlineMedium!.copyWith(color: appTheme.teal900,
      );

  static TextStyle get headlineSmallPoppinsGray50 =>
      theme.textTheme.headlineSmall!.poppins.copyWith(
        color: appTheme.gray50,
        fontWeight: FontWeight.w500,
      );

// Label text style
  static TextStyle get labelLargeBlueGray800 =>
      theme.textTheme.labelLarge!.copyWith(
        color: appTheme.blueGray800.withOpacity(0.6),
      );

  static TextStyle get labelLargeBold =>
      theme.textTheme.labelLarge!.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get labelLargeLightGreen50 =>
      theme.textTheme.labelLarge!.copyWith(
        color: appTheme.lightGreen50.withOpacity(0.4),
      );

  static TextStyle get labelLargeTea1900 =>
      theme.textTheme.labelLarge!.copyWith(color: appTheme.teal900,
      );

  static TextStyle get labelMediumBlueGray800 =>
      theme.textTheme.labelMedium!.copyWith(color: appTheme.blueGray800,
      );

  static TextStyle get labelMediumLightGreen50 =>
      theme.textTheme.labelMedium!.copyWith(
        color: appTheme.lightGreen50.withOpacity(0.4,),
      );

  static TextStyle get labelMediumLightGreen50_1 =>
      theme.textTheme.labelMedium!.copyWith(color: appTheme.lightGreen50,
      );

// Title text style
  static TextStyle get titleLargeMedium =>
      theme.textTheme.titleLarge!.copyWith(fontSize: 20,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get titleMediumBold =>
      theme.textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.w700,
      );

  static TextStyle get titleMediumLightGreen50 =>
      theme.textTheme.titleMedium!.copyWith(color: appTheme.lightGreen50,
      );

  static TextStyle get titleMediumLightGreen50SemiBold =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.lightGreen50,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get titleMediumLightGreen50_1 =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.lightGreen50.withOpacity(0.4),
      );

  static TextStyle get titleMediumOnPrimary =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onPrimary,
      );

  static TextStyle get titleMediumRed400 =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.red400,
      );

  static TextStyle get titleMediumSemiBold =>
      theme.textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.w600,
      );

  static TextStyle get titleMediumTeal900 =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.teal900,
      );

  static TextStyle get titleSmallBlueGray800 =>
      theme.textTheme.titleSmall!.copyWith(
        color: appTheme.blueGray800,
      );

  static TextStyle get titleSmallBlueGray800_1 =>
      theme.textTheme.titleSmall!.copyWith(
        color: appTheme.blueGray800.withOpacity(0.6,),
      );

  static TextStyle get titleSmallLightGreen100 =>
      theme.textTheme.titleSmall!.copyWith(
        color: appTheme.lightGreen100,
      );

  static TextStyle get titleSmallLightGreen50 =>
      theme.textTheme.titleSmall!.copyWith(
        color: appTheme.lightGreen50.withOpacity(0.4),
      );

  static TextStyle get titleSmallOnPrimary =>
      theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.onPrimary,
      );

  static TextStyle get titleSmallTea1900 =>
      theme.textTheme.titleSmall!.copyWith(
        color: appTheme.teal900,
      );
}
