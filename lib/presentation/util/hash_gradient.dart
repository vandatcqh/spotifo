import 'dart:math';

import 'package:flutter/material.dart';

int hashString(String str) {
  int hash = 5381;
  const int mod = 0x7FFFFFFF; // 32-bit signed integer range
  for (int i = 0; i < str.length; i++) {
    hash = ((hash << 5) + hash) ^ str.codeUnitAt(i) << (i % 8); // hash * 33 ^ char
    hash = hash & mod; // Keep it within 32-bit range
  }
  return hash;
}

HSLColor hashToHSL(int hash, {int index = 0}) {
  final offset = index * 465;
  final hue = (hash + offset).abs() % 377 % 360;
  final saturation = 60 + (hash + offset).abs() % 10;
  final lightness = 45 + (hash + offset).abs() % 10;
  return HSLColor.fromAHSL(1.0, hue as double, saturation / 100.0, lightness / 100.0);
}

Alignment getGradientRotate(num degree) {
  degree -= 90;
  final x = cos(degree * pi / 180);
  final y = sin(degree * pi / 180);
  final xAbs = x.abs();
  final yAbs = y.abs();

  if ((0.0 < xAbs && xAbs < 1.0) || (0.0 < yAbs && yAbs < 1.0)) {
    final magnification = (1 / xAbs) < (1 / yAbs) ? (1 / xAbs) : (1 / yAbs);
    return Alignment(x, y) * magnification;
  } else {
    return Alignment(x, y);
  }
}

LinearGradient generateHashGradient(String str) {
  final baseHash = hashString(str);
  final colorCount = baseHash % 2 == 0 ? 2 : 2;
  final angle = (baseHash % 15) * 45 + (baseHash % 20) * 15 - (baseHash % 36) * 10;  // Random rotation for the gradient

  final colors = List.generate(colorCount, (i) => hashToHSL(baseHash, index: i));

  return LinearGradient(
    begin: -getGradientRotate(angle),
    end: getGradientRotate(angle),
    colors: colors.map((color) => color.toColor()).toList(),
  );
}
