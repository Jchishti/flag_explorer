import 'package:flutter/material.dart';

import '../models/flag_template.dart';

/// Renders a flag template and lets the user tap regions to fill them.
class FlagCanvas extends StatelessWidget {
  const FlagCanvas({
    super.key,
    required this.template,
    required this.regionColors,
    required this.onRegionTap,
    this.showOutlinesOnly = false,
  });

  final FlagTemplate template;

  /// Current fill color for each region (indexed same as template.regions).
  final List<Color?> regionColors;

  /// Called when a region is tapped with its index.
  final ValueChanged<int> onRegionTap;

  /// If true, draw outlines only (no fills) — used for the blank canvas.
  final bool showOutlinesOnly;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Flag aspect ratio 3:2.
        final width = constraints.maxWidth;
        final height = width * 2 / 3;

        return SizedBox(
          width: width,
          height: height,
          child: GestureDetector(
            onTapDown: (details) => _handleTap(details, width, height),
            child: CustomPaint(
              size: Size(width, height),
              painter: _FlagPainter(
                template: template,
                regionColors: regionColors,
                showOutlinesOnly: showOutlinesOnly,
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleTap(TapDownDetails details, double width, double height) {
    final dx = details.localPosition.dx / width; // normalize 0..1
    final dy = details.localPosition.dy / height;

    // Walk regions in reverse so topmost (last drawn) wins.
    for (int i = template.regions.length - 1; i >= 0; i--) {
      final r = template.regions[i].rect;
      if (dx >= r.left && dx <= r.right && dy >= r.top && dy <= r.bottom) {
        onRegionTap(i);
        return;
      }
    }
  }
}

class _FlagPainter extends CustomPainter {
  _FlagPainter({
    required this.template,
    required this.regionColors,
    required this.showOutlinesOnly,
  });

  final FlagTemplate template;
  final List<Color?> regionColors;
  final bool showOutlinesOnly;

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()..style = PaintingStyle.fill;
    final outlinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.grey.shade400
      ..strokeWidth = 1.5;

    for (int i = 0; i < template.regions.length; i++) {
      final region = template.regions[i];
      final color = regionColors[i];

      // Scale normalized rect to actual canvas size.
      final rect = Rect.fromLTWH(
        region.rect.left * size.width,
        region.rect.top * size.height,
        region.rect.width * size.width,
        region.rect.height * size.height,
      );

      final isCircle = region.label.toLowerCase().contains('circle') ||
          region.label.toLowerCase().contains('sun');

      if (showOutlinesOnly) {
        // Reference: show the correct color.
        fillPaint.color = region.correctColor;
        if (isCircle) {
          canvas.drawOval(rect, fillPaint);
        } else {
          canvas.drawRect(rect, fillPaint);
        }
      } else {
        // Coloring canvas: show user color or empty.
        if (color != null) {
          fillPaint.color = color;
          if (isCircle) {
            canvas.drawOval(rect, fillPaint);
          } else {
            canvas.drawRect(rect, fillPaint);
          }
        }
        // Always draw outline so the child knows where to tap.
        if (isCircle) {
          canvas.drawOval(rect, outlinePaint);
        } else {
          canvas.drawRect(rect, outlinePaint);
        }
      }
    }

    // Outer border.
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.black54
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_FlagPainter old) => true;
}
