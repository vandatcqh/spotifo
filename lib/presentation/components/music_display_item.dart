import 'package:flutter/material.dart';
import 'package:spotifo/core/app_export.dart';

class MusicDisplayItem extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final String? label;
  final String? description;
  final VoidCallback? onPressed;

  const MusicDisplayItem({
    super.key,
    this.imageUrl,
    this.size = 120,
    this.label,
    this.description,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed, // Call the passed-in function when pressed
      child: SizedBox(
        width: size,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl ?? '',
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: size,
                    height: size,
                    color: Colors.grey.shade300,
                    child: const Icon(
                      Icons.music_note,
                      size: 40,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 4),
            if (label != null)
              Text(
                label!,
                style: textTheme.labelMedium?.withColor(colorTheme.onSurface),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            if (description != null)
              Text(
                description!,
                style: textTheme.labelSmall?.withColor(colorTheme.onSurface.withAlphaD(0.6)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}
