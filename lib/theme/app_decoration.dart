import 'package:flutter/material.dart';

enum GradientType { linear, radial }

class GradientBoxDecoration extends BoxDecoration {
  GradientBoxDecoration({
    super.image,
    super.border,
    super.borderRadius,
    super.boxShadow,
    Gradient? gradient,
    super.backgroundBlendMode,
    super.shape,
    AlignmentGeometry? alignment,
    required GradientType gradientType,
    List<Color>? colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    double radius = 0.5,
  }) : super(
          gradient: gradient ??
              (gradientType == GradientType.linear
                  ? LinearGradient(
                      colors: colors ??  [Colors.black, Colors.white],
                      stops: stops,
                      begin: begin ?? Alignment.topLeft,
                      end: end ?? Alignment.bottomRight,
                    )
                  : RadialGradient(
                      colors: colors ??  [Colors.black, Colors.white],
                      stops: stops,
                      radius: radius,
                      center: begin ?? Alignment.center,
                    )),
        );
}

class AppDecoration {
  // Gradient decorations
  static BoxDecoration get gradientA => GradientBoxDecoration(
        gradientType: GradientType.linear,
        begin: Alignment(0.11, 1.18),
        end: Alignment(1.04, 0.32),
        colors: [Color(0xFF6D77DE), Color(0xFF4FD9AD)],
      );

  static BoxDecoration get gradientB => GradientBoxDecoration(
        gradientType: GradientType.linear,
        begin: Alignment(0, 1),
        end: Alignment(1, 0.07),
        colors: [Color(0xFFDE6DDE), Color(0xFF5022BB)],
      );

  static BoxDecoration get gradientC => GradientBoxDecoration(
        gradientType: GradientType.linear,
        begin: Alignment(0.53, 1.2),
        end: Alignment(-0.02, -0.15),
        colors: [Color(0xFF358CEF), Color(0xFFE674E2)],
      );

  static BoxDecoration get gradientD => GradientBoxDecoration(
        gradientType: GradientType.linear,
        begin: Alignment(0.13, 0.77),
        end: Alignment(0.94, 0.05),
        colors: [Color(0xFF58AE5B), Color(0xFF554DBA)],
      );

  static BoxDecoration get gradientE => GradientBoxDecoration(
        gradientType: GradientType.linear,
        begin: Alignment(0.89, 0.97),
        end: Alignment(-0.02, -0.15),
        colors: [Color(0xFFE4C56E), Color(0xFFDD3E3E)],
      );

  static BoxDecoration get gradientF => GradientBoxDecoration(
        gradientType: GradientType.linear,
        begin: Alignment(0, 0.5),
        end: Alignment(1, 0.5),
        colors: [Color(0xFF4BBCAF), Color(0xFF6E8AE4), Color(0xFFE62974)],
      );

  static BoxDecoration get gradientG => GradientBoxDecoration(
        gradientType: GradientType.linear,
        begin: Alignment(0.43, 0.33),
        end: Alignment(0.97, 0.97),
        colors: [Color(0xFFF85759), Color(0xFF4BBCAF)],
      );

  static BoxDecoration get gradientH => GradientBoxDecoration(
        gradientType: GradientType.linear,
        begin: Alignment(0, 1),
        end: Alignment(1, 0.07),
        colors: [Color(0xFFBA6566), Color(0xFF5244A4), Color(0xFF288585)],
        stops: [0.0, 0.61, 1.0]
      );
}
