import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../../core/app_export.dart';

// ignore_for_file: must_be_immutable
class CustomSwitch extends StatelessWidget {
  CustomSwitch(
      {super.key,
        required this.onChange,
        this.alignment,
        this.value,
        this.width,
        this.height,
        this.margin});

  final Alignment? alignment;
  bool? value;
  final Function (bool) onChange;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        margin: margin,
        child: alignment != null
            ? Align(
            alignment: alignment ?? Alignment.center, child: switchWidget)
            : switchWidget);
  }


  Widget get switchWidget => FlutterSwitch(
    value: value ?? false,
    height: 30.h,
    width: 52.h,
    toggleSize: 18,
    borderRadius: 14.h,
    switchBorder: Border.all(
      color: colorTheme.primary,
      width: 1.h,
    ),
    activeColor: colorTheme.onPrimary,
    activeToggleColor: colorTheme.surface,
    inactiveColor: colorTheme.onSecondary,
    inactiveToggleColor: colorTheme.surface,
    onToggle: (value) {
      onChange(value);
    },
  );
}