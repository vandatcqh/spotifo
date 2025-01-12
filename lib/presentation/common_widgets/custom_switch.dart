import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../../core/app_export.dart';

// ignore_for_file: must_be_immutable
class CustomSwitch extends StatelessWidget {
  CustomSwitch(
      {Key? key,
        required this.onChange,
        this.alignment,
        this.value,
        this.width,
        this.height,
        this.margin})
      : super(
    key: key,
  );

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
      color: theme.colorScheme.onPrimaryContainer,
      width: 1.h,
    ),
    activeColor: appTheme.orange20001,
    activeToggleColor: appTheme.lightGreen50,
    inactiveColor: appTheme.blueGray800,
    inactiveToggleColor: appTheme.lightGreen50,
    onToggle: (value) {
      onChange(value);
    },
  );
}