import 'package:flutter/material.dart';

class MarkerInfoRow extends StatelessWidget {
  final Widget icon;
  final String text;
  final int maxLines;
  final bool isTitle;
  final double zoom;

  const MarkerInfoRow({
    Key? key,
    required this.icon,
    required this.text,
    required this.zoom,
    this.maxLines = 1,
    this.isTitle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 18 * zoom,
          height: 18 * zoom,
          child: icon,
        ),
        SizedBox(width: 4 * zoom),
        // Expanded is OK here because parent is Row
        Expanded(
          child: Text(
            text,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: (isTitle ? 14 : 12) * zoom,
              fontWeight: isTitle ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}