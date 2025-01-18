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
                      colors: colors ?? [Colors.black, Colors.white],
                      stops: stops,
                      begin: begin ?? Alignment.topLeft,
                      end: end ?? Alignment.bottomRight,
                    )
                  : RadialGradient(
                      colors: colors ?? [Colors.black, Colors.white],
                      stops: stops,
                      radius: radius,
                      center: begin ?? Alignment.center,
                    )),
        );
}

class AppDecoration {
  static Gradient get spotlight => RadialGradient(
        colors: [Color(0xFFFFBB56), Color(0xFFC44D4F), Color(0xFF143D5D), Color(0xFF011C39)],
        stops: [0.0, 0.32, 0.7, 1.0],
        center: Alignment.topCenter,
        radius: 1.5,
      );
}
