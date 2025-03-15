import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:fx_2_folder/smoke/animation_sequence.dart';
import 'package:fx_2_folder/smoke/circle_data.dart';

class AnimatedCircles extends StatefulWidget {
  const AnimatedCircles({super.key, required this.sequence});

  final AnimationSequence sequence;

  @override
  AnimatedCirclesState createState() => AnimatedCirclesState();
}

class AnimatedCirclesState extends State<AnimatedCircles> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.sequence.stepDuration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: Tween<double>(begin: 0, end: 1).animate(_controller),
      curve: Curves.linear,
    );

    _controller.addStatusListener(_updateSequence);
    _controller.forward();
  }

  void _updateSequence(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.sequence.length;
        widget.sequence.onSequenceChange?.call(_currentIndex);
      });
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(screenSize.width, screenSize.height),
          painter: CirclesPainter(
            startCircles: widget.sequence.sequences[_currentIndex],
            endCircles: widget.sequence.sequences[(_currentIndex + 1) % widget.sequence.length],
            progress: _animation.value,
          ),
        );
      },
    );
  }
}

class CirclesPainter extends CustomPainter {
  CirclesPainter({
    required this.startCircles,
    required this.endCircles,
    required this.progress,
  });

  final List<CircleData> startCircles;
  final List<CircleData> endCircles;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42); // Fixed seed for consistent curves
    for (var i = 0; i < startCircles.length; i++) {
      final startCircle = startCircles[i];
      final endCircle = endCircles.firstWhere(
        (c) => c.id == startCircle.id,
        orElse: () => startCircle,
      );
      final lerpedCircle = startCircle.lerp(endCircle, progress);

      // Generate control points for the Bézier curve
      final controlPoint1 = _generateControlPoint(
        startCircle.normalizedPosition,
        endCircle.normalizedPosition,
        random,
      );
      final controlPoint2 = _generateControlPoint(
        startCircle.normalizedPosition,
        endCircle.normalizedPosition,
        random,
      );

      // Calculate the position along the Bézier curve
      var position = _calculateBezierPoint(
        startCircle.normalizedPosition,
        controlPoint1,
        controlPoint2,
        endCircle.normalizedPosition,
        progress,
      );

      // Convert normalized position to actual position
      position = Offset(position.dx * size.width, position.dy * size.height);
      // var position = Offset(lerpedCircle.normalizedPosition.dx * size.width,
      //     lerpedCircle.normalizedPosition.dy * size.height);

      final paint = Paint()
        ..color = lerpedCircle.color.withValues(alpha: 1)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100);

      canvas.drawCircle(position, lerpedCircle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  Offset _generateControlPoint(Offset start, Offset end, math.Random random) {
    final midX = (start.dx + end.dx) / 2;
    final midY = (start.dy + end.dy) / 2;

    // Add some randomness to the control point
    final offsetX = (random.nextDouble() - 0.5) * 1; // Adjust the 0.5 to control the curve intensity
    final offsetY = (random.nextDouble() - 0.5) * 1;

    return Offset(midX + offsetX, midY + offsetY);
  }

  Offset _calculateBezierPoint(
    Offset p0,
    Offset p1,
    Offset p2,
    Offset p3,
    double t,
  ) {
    final x = _bezierValue(p0.dx, p1.dx, p2.dx, p3.dx, t);
    final y = _bezierValue(p0.dy, p1.dy, p2.dy, p3.dy, t);
    return Offset(x, y);
  }

  double _bezierValue(double p0, double p1, double p2, double p3, double t) {
    return math.pow(1 - t, 3) * p0 +
        3 * math.pow(1 - t, 2) * t * p1 +
        3 * (1 - t) * math.pow(t, 2) * p2 +
        math.pow(t, 3) * p3;
  }
}
