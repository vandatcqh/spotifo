import 'package:flutter/material.dart';
import '../core/app_export.dart';
class AppDecoration {
// Fill decorations
  static BoxDecoration get fillBlueGrayF =>
      BoxDecoration(
        color: appTheme.blueGray1007f,
      );

  static BoxDecoration get fillOnPrimaryContainer =>
      BoxDecoration(
        color: theme.colorScheme.onPrimaryContainer,
      );

  static BoxDecoration get fillRed =>
      BoxDecoration(
        color: appTheme.red200,
      );

  // Gradient decorations
  static BoxDecoration get gradientBlueToPurpleA =>
      BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.11, 1.18),
          end: Alignment(1.04, 0.32),
          colors: [appTheme.blue500, appTheme.purpleA100],
        ),
      );

  static BoxDecoration get gradientErrorContainerToPink =>
      BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0, 1),
          end: Alignment(1, 0.07),
          colors: [theme.colorScheme.errorContainer, appTheme.pink400],
        ),
      );

  static BoxDecoration get gradientGreenToDeepPurple =>
      BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0, 1),
          end: Alignment(1, 0.07),
          colors: [appTheme.greenA200, appTheme.deepPurple800],
        ),
      );

  static BoxDecoration get gradientGreenToIndigo =>
      BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.53, 1.2),
          end: Alignment(-0.02, -0.15),
          colors: [appTheme.green500, appTheme.indigo500],
        ),
      );

  static BoxDecoration get gradientIndigoToIndigo =>
      BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [appTheme.indigo900, appTheme.indigo400],
        ),
      );

  static BoxDecoration get gradientIndigoToTeal =>
      BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.13, 0.77),
          end: Alignment(0.94, 0.05),
          colors: [appTheme.indigo300, appTheme.teal300],
        ),
      );

  static BoxDecoration get gradientOrangeToRed =>
      BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.89, 0.97),
          end: Alignment(-0.02, -0.15),
          colors: [appTheme.orange200, appTheme.red600],
        ),
      );

  static BoxDecoration get gradientPrimaryContainerToLightGreen =>
      BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0, 0.5),
          end: Alignment(1, 0.5),
          colors: [theme.colorScheme.primaryContainer, appTheme.lightGreen100],
        ),
      );

  static BoxDecoration get gradientPrimaryToLightGreen =>
      BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0, 0.5),
          end: Alignment(1, 0.5),
          colors: [theme.colorScheme.primary, appTheme.lightGreen100],
        ),
      );

  static BoxDecoration get gradientPurpleAToDeepPurple =>
      BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.43, 0.33),
          end: Alignment(0.97, 0.97),
          colors: [appTheme.purpleA10001, appTheme.deepPurple700],
        ),
      );

  static BoxDecoration get gradientRedATOSecondaryContainer =>
      BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.27, -0.18),
          end: Alignment(1.17, 1.13),
          colors: [appTheme.redA200, theme.colorScheme.secondaryContainer],
        ),
      );

  static BoxDecoration get gradientRedToPurple =>
      BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0, 1),
          end: Alignment(1, 0.07),
          colors: [appTheme.red500, appTheme.purple500],
        ),
      );

  static BoxDecoration get gradientRedToTeal =>
      BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(1.17, -0.52),
          end: Alignment(0.05, 1),
          colors: [appTheme.red300, appTheme.deepPurple70001, appTheme.teal400],
        ),
      );

  static BoxDecoration get gradientSecondaryContainerToPink =>
      BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.98, 0.94),
          end: Alignment(0.03, 0.1),
          colors: [
            theme.colorScheme.secondaryContainer,
            appTheme.indigo30001,
            appTheme.pink400
          ],
        ),
      );

  static BoxDecoration get gradientTealToLime =>
      BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0, 1),
          end: Alignment(1, 0.07),
          colors: [appTheme.tealA400, appTheme.lime700],
        ),
      );

  static BoxDecoration get gradientWhiteToWhite =>
      BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.onPrimaryContainer,
          width: 3.h,
        ),
        gradient: LinearGradient(
          begin: Alignment(0.11, 1.18),
          end: Alignment(1.84, 8.32),
          colors: [appTheme.whiteA700, appTheme.whiteA700],
        ),
      );

// Light decorations
  static BoxDecoration get lightonSecondary =>
      BoxDecoration(
        color: appTheme.lightGreen100,
      );

  static BoxDecoration get lightSurface =>
      BoxDecoration(
        color: appTheme.lightGreen50,
      );

  static BoxDecoration get lightSurface84 =>
      BoxDecoration(
        color: appTheme.lightGreen50.withOpacity(0.4),
      );
}

class BorderRadiusStyle {
// Circle borders
  static BorderRadius get circleBorder16 =>
      BorderRadius.circular(
        16.h,
      );

// Rounded borders
  static BorderRadius get roundedBorder10 =>
      BorderRadius.circular(
        10.h,
      );

  static BorderRadius get roundedBorder2 =>
      BorderRadius.circular(
        2.h,
      );

  static BorderRadius get roundedBorder20 =>
      BorderRadius.circular(
        20.h,
      );

  static BorderRadius get roundedBorders =>
      BorderRadius.circular(
        5.h,
      );

  static BorderRadius get roundedBorder74 =>
      BorderRadius.circular(
        74.h,);
}
