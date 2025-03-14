import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A widget that displays text rotating in a circular pattern.
///
/// ASCII Visualization of how it works:
/// ```log
///      Top (-π/2)
///         |
///    \    |    /
///     \   |   /
///      \  |  /
///       \ | /
/// Left ---+--- Right (0)
///       / | \
///      /  |  \
///     /   |   \
///    /    |    \
///         |
///      Bottom (π/2)
/// ```
class RotatingTextWidget extends StatefulWidget {
  const RotatingTextWidget({
    super.key,
    required this.text,
    required this.radius,
    required this.textStyle,
    required this.rotationDuration,
  });
  final String text;
  final double radius;
  final TextStyle textStyle;
  final Duration rotationDuration;

  @override
  RotatingTextWidgetState createState() => RotatingTextWidgetState();
}

class RotatingTextWidgetState extends State<RotatingTextWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.rotationDuration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.radius * 2, widget.radius * 2),
          painter: _CircularTextPainter(
            text: widget.text,
            radius: widget.radius,
            textStyle: widget.textStyle,
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

/// Handles the actual drawing of text in a circular pattern
class _CircularTextPainter extends CustomPainter {
  _CircularTextPainter({
    required this.text,
    required this.radius,
    required this.textStyle,
    required this.progress,
  });
  final String text;
  final double radius;
  final TextStyle textStyle;
  final double progress;

  // Cached center coordinates
  late final double _centerX;
  late final double _centerY;

  @override
  void paint(Canvas canvas, Size size) {
    _centerX = size.width / 2;
    _centerY = size.height / 2;

    final calculator = RotationCalculator(
      text: text,
      radius: radius,
      textStyle: textStyle,
      progress: progress,
    );

    // Get all the measurements we need
    final measurements = calculator.calculateSegmentMeasurements();

    // Draw the text segments around the circle
    _drawRepeatingSegments(canvas, measurements);
  }

  /// Draws all segments of text around the circle
  void _drawRepeatingSegments(Canvas canvas, SegmentMeasurements measurements) {
    var startAngle = measurements.initialStartAngle;

    for (var rep = 0; rep < measurements.repetitions; rep++) {
      // 1. Draw the dot
      _drawDot(canvas, startAngle);

      // 2. Draw the text segment
      _drawTextSegment(
        canvas,
        startAngle + measurements.dotAngle / 2,
        measurements.textAngle,
        measurements.segmentAngle,
      );

      // 3. Move to next segment
      startAngle += measurements.segmentAngle;
    }
  }

  /// Draws a single segment of text along the circle
  void _drawTextSegment(
    Canvas canvas,
    double startAngle,
    double textAngle,
    double segmentAngle,
  ) {
    // 1. Calculate character widths
    final charMeasurements = _measureCharacters();

    // 2. Draw each character
    var currentAngle = startAngle;
    for (var i = 0; i < text.length; i++) {
      _drawCharacter(
        canvas,
        text[i],
        currentAngle,
        textAngle,
        charMeasurements.charWidths[i],
        charMeasurements.totalWidth,
      );

      // Move angle for next character
      final charProportion = charMeasurements.charWidths[i] / charMeasurements.totalWidth;
      currentAngle += textAngle * charProportion;
    }
  }

  /// Draws a single character at the specified angle
  void _drawCharacter(
    Canvas canvas,
    String char,
    double currentAngle,
    double textAngle,
    double charWidth,
    double totalCharWidth,
  ) {
    final textPainter = _createTextPainter(char);

    // Calculate character's angle and position
    final charProportion = charWidth / totalCharWidth;
    final charAngle = textAngle * charProportion;
    final charCenterAngle = currentAngle + (charAngle / 2);

    // Calculate position on circle
    final position = _calculatePositionOnCircle(charCenterAngle);

    // Draw the character
    _paintRotatedCharacter(
      canvas,
      textPainter,
      position,
      charCenterAngle,
      charWidth,
    );
  }

  /// Creates a TextPainter for a single character
  TextPainter _createTextPainter(String char) {
    final textSpan = TextSpan(text: char, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return textPainter;
  }

  /// Calculates position on the circle for given angle
  Offset _calculatePositionOnCircle(double angle) {
    final x = _centerX + radius * math.cos(angle);
    final y = _centerY + radius * math.sin(angle);
    return Offset(x, y);
  }

  /// Paints a rotated character at the specified position
  void _paintRotatedCharacter(
    Canvas canvas,
    TextPainter painter,
    Offset position,
    double angle,
    double charWidth,
  ) {
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(angle + math.pi / 2);
    painter.paint(canvas, Offset(-charWidth / 2, -painter.height / 2));
    canvas.restore();
  }

  /// Draws a dot at the specified angle
  void _drawDot(Canvas canvas, double angle) {
    final dotRadius = textStyle.fontSize! / 4;
    final dotPaint = Paint()
      ..color = textStyle.color!
      ..style = PaintingStyle.fill;

    final dotPosition = _calculatePositionOnCircle(angle);
    canvas.drawCircle(dotPosition, dotRadius, dotPaint);
  }

  /// Measures all characters in the text
  CharacterMeasurements _measureCharacters() {
    final charWidths = <double>[];
    double totalWidth = 0;

    for (var i = 0; i < text.length; i++) {
      final painter = _createTextPainter(text[i]);
      charWidths.add(painter.width);
      totalWidth += painter.width;
    }

    return CharacterMeasurements(
      charWidths: charWidths,
      totalWidth: totalWidth,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Handles calculations for text rotation and spacing
class RotationCalculator {
  RotationCalculator({
    required this.text,
    required this.radius,
    required this.textStyle,
    required this.progress,
  });
  final String text;
  final double radius;
  final TextStyle textStyle;
  final double progress;

  /// Calculates all measurements needed for text segments
  SegmentMeasurements calculateSegmentMeasurements() {
    const totalAngle = 2 * math.pi;
    final startAngle = -math.pi / 2 + (progress * totalAngle);

    // Calculate text and dot sizes
    final textWidth = _calculateTextWidth();
    final dotWidth = textStyle.fontSize!;
    final totalWidth = textWidth + dotWidth;

    // Calculate repetitions
    var repetitions = (totalAngle * radius / totalWidth).floor();
    repetitions = math.max(1, repetitions);

    // Calculate angles
    final segmentAngle = totalAngle / repetitions;
    final textAngle = (textWidth / totalWidth) * segmentAngle;
    final dotAngle = segmentAngle - textAngle;

    return SegmentMeasurements(
      initialStartAngle: startAngle,
      repetitions: repetitions,
      segmentAngle: segmentAngle,
      textAngle: textAngle,
      dotAngle: dotAngle,
    );
  }

  /// Calculates total width of text
  double _calculateTextWidth() {
    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return textPainter.width;
  }
}

/// Stores measurements for text characters
class CharacterMeasurements {
  CharacterMeasurements({
    required this.charWidths,
    required this.totalWidth,
  });
  final List<double> charWidths;
  final double totalWidth;
}

/// Stores measurements for text segments
class SegmentMeasurements {
  SegmentMeasurements({
    required this.initialStartAngle,
    required this.repetitions,
    required this.segmentAngle,
    required this.textAngle,
    required this.dotAngle,
  });
  final double initialStartAngle;
  final int repetitions;
  final double segmentAngle;
  final double textAngle;
  final double dotAngle;
}
