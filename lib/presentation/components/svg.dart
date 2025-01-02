import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SVG extends StatelessWidget {
  final String assetName;
  final double? width;
  final double? height;
  final double? size;
  final BoxFit fit;
  final Color? color;

  const SVG(this.assetName, {
    super.key,
    this.width,
    this.height,
    this.size,
    this.fit = BoxFit.contain,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    final double? finalWidth = width ?? (size);
    final double? finalHeight = height ?? (size);

    return SvgPicture.asset(
      assetName,
      width: finalWidth,
      height: finalHeight,
      fit: fit,
      colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    );
  }
}
