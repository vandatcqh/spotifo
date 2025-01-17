import 'package:flutter/material.dart';
import '../../core/app_export.dart';
extension IconButtonStyleHelper on CustomIconButton {
  static BoxDecoration get fillOnPrimaryContainer =>
      BoxDecoration(
        color: colorTheme.onPrimaryContainer,
        borderRadius: BorderRadius.circular(20.h),
      );

  static BoxDecoration get fillTeal =>
      BoxDecoration(
        color: colorTheme.secondary,
        borderRadius: BorderRadius.circular(4.h),
      );

  static BoxDecoration get fillLightGreen =>
      BoxDecoration(
        color: colorTheme.surface.withAlphaD(0.4),
        borderRadius: BorderRadius.circular(4.h),
      );
  static BoxDecoration get none => BoxDecoration();
}



class CustomIconButton extends StatelessWidget {
  const CustomIconButton({super.key,
    this.alignment,
    this.height,
    this.width,
    this.decoration,
    this.padding,
    this.onTap,
    this.child});

  final Alignment? alignment;
  final double? height;
  final double? width;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
        alignment: alignment ?? Alignment.center, child: iconButtonWidget)
        : iconButtonWidget;
  }

  Widget get iconButtonWidget =>
      SizedBox(
        height: height ?? 0,
        width: width ?? 0,
        child: DecoratedBox(
          decoration: decoration ??
              BoxDecoration(
                color: colorTheme.surface.withAlphaD(0.4),
                borderRadius: BorderRadius.circular(14.h),
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 2.h, blurRadius: 2.h,
                  )
                ],
              ),
          child: IconButton(
            padding: padding ?? EdgeInsets.zero,
            onPressed: onTap,
            icon: child ?? Container(),
          ),
        ),
      );
}
