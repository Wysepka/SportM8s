import 'package:flutter/material.dart';

import '../../graphics/sportm8s_themes.dart';

class CalendarOverlappingAvatars extends StatelessWidget {
  final List<String> imageUrls;
  final int currentCount;
  final int maxCount;

  const CalendarOverlappingAvatars({
    super.key,
    required this.imageUrls,
    required this.currentCount,
    required this.maxCount,
  });

  @override
  Widget build(BuildContext context) {
    const double avatarSize = 28;
    const double overlapOffset = 16;

    final int visibleCount = imageUrls.length;
    final double avatarsWidth =
    visibleCount > 0 ? avatarSize + (visibleCount - 1) * overlapOffset : 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: avatarsWidth,
          height: avatarSize,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              for (int i = 0; i < visibleCount; i++)
                Positioned(
                  left: i * overlapOffset,
                  child: Container(
                    width: avatarSize,
                    height: avatarSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: avatarSize / 2,
                      backgroundImage: NetworkImage(imageUrls[i]),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: SportM8sColors.tertiaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$currentCount / $maxCount',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}