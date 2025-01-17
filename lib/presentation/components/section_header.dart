import 'package:flutter/material.dart';
import 'package:spotifo/core/app_export.dart';
import 'package:spotifo/presentation/components/svg.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onIconPressed; // Callback cho icon
  final bool showIcon;

  const SectionHeader({
    super.key,
    required this.title,
    required this.onIconPressed,
    required this.showIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: textTheme.titleMedium?.withColor(colorTheme.onSurface),
        ),
        if (showIcon)
          IconButton(
            icon: SVG("assets/svgs/heroicons-solid/chevron-right.svg", size: 16, color: colorTheme.onSurface),
            onPressed: onIconPressed, // Khi nhấn vào icon
          ),
      ],
    );
  }
}
