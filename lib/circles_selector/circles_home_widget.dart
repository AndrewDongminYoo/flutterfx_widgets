import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class CirclesHomeWidget extends StatelessWidget {
  const CirclesHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PannableCircleGrid(),
    );
  }
}

class PannableCircleGrid extends StatefulWidget {
  const PannableCircleGrid({super.key});

  @override
  PannableCircleGridState createState() => PannableCircleGridState();
}

class PannableCircleGridState extends State<PannableCircleGrid> with TickerProviderStateMixin {
  static const double _circleSize = 80;
  static const double _selectedCircleMultiplier = 2;
  static const double _spacing = 10;
  static const int _columns = 1000;

  Offset _offset = Offset.zero;
  final Map<int, AnimationController> _animationControllers = {};
  int? _selectedIndex;

  late AnimationController _flingAnimationController;
  Offset _flingVelocity = Offset.zero;

  final SpringDescription spring = const SpringDescription(
    mass: 2,
    stiffness: 150,
    damping: 20,
  );

  final SpringDescription quickOvershootSpring = const SpringDescription(
    mass: 2,
    stiffness: 600,
    damping: 8,
  );

  @override
  void initState() {
    super.initState();
    _flingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _flingAnimationController.addListener(_handleFlingAnimation);
  }

  @override
  void dispose() {
    for (final controller in _animationControllers.values) {
      controller.dispose();
    }
    _flingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _handlePan,
      onPanEnd: _handlePanEnd,
      child: ColoredBox(
        color: Colors.black,
        child: Stack(
          children: [
            ClipRect(
              child: Stack(
                children: [
                  AnimatedBuilder(
                    animation: Listenable.merge(_animationControllers.values.toList()),
                    builder: (context, child) {
                      return CustomPaint(
                        painter: CircleGridPainter(
                          offset: _offset,
                          circleSize: _circleSize,
                          selectedCircleMultiplier: _selectedCircleMultiplier,
                          spacing: _spacing,
                          selectedIndex: _selectedIndex,
                          columns: _columns,
                          animationControllers: _animationControllers,
                        ),
                        child: GestureDetector(
                          onTapUp: _handleTap,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Bottom gradient overlay
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black,
                      Colors.black,
                      Colors.black,
                      Colors.black.withValues(alpha: 0.9),
                      Colors.black.withValues(alpha: 0.8),
                      Colors.black.withValues(alpha: 0.7),
                      Colors.black.withValues(alpha: 0.5),
                      Colors.black.withValues(alpha: 0.3),
                      Colors.black.withValues(alpha: 0.1),
                      Colors.transparent,
                      Colors.transparent,
                    ],
                    stops: const [
                      0.0,
                      0.1,
                      0.2,
                      0.3,
                      0.4,
                      0.5,
                      0.6,
                      0.7,
                      0.8,
                      0.9,
                      1.0,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePan(DragUpdateDetails details) {
    setState(() {
      _offset += details.delta;
    });
    debugPrint('Pan update: ${details.delta}'); // De
  }

  void _handlePanEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond;
    final speed = velocity.distance;

    if (speed > 50) {
      _flingVelocity = velocity * 0.006; // Adjust this factor to tune the feel

      const double maxSpeed = 200; // Adjust this value to set the maximum fling speed
      if (_flingVelocity.distance > maxSpeed) {
        _flingVelocity = (_flingVelocity / _flingVelocity.distance) * maxSpeed;
      }
      debugPrint('Fling started - Velocity: $_flingVelocity');

      _flingAnimationController.reset();
      _flingAnimationController.forward();
    }
  }

  void _handleFlingAnimation() {
    if (!_flingAnimationController.isAnimating) {
      return;
    }

    final t = _flingAnimationController.value;
    final easeOutFactor = Curves.decelerate.transform(1 - t);

    setState(() {
      _offset += _flingVelocity * easeOutFactor;
    });

    // Stop the animation if the movement becomes very small
    if (_flingVelocity.distance * easeOutFactor < 0.01) {
      _flingAnimationController.stop();
    }
  }

  void _handleTap(TapUpDetails details) {
    final tapPosition = details.localPosition;
    final col = ((tapPosition.dx - _offset.dx + _circleSize / 2) / (_circleSize + _spacing)).floor();
    final row = ((tapPosition.dy - _offset.dy + _circleSize / 2) / (_circleSize + _spacing)).floor();
    final tappedIndex = row * _columns + col;

    setState(() {
      if (_selectedIndex == tappedIndex) {
        // Case 1: Tapping the same circle
        final simulation = SpringSimulation(spring, 1, 0, -1);
        // ignore: discarded_futures
        _animationControllers[tappedIndex]?.animateWith(simulation).then((_) {
          if (mounted) {
            setState(() {
              _animationControllers.remove(tappedIndex);
              _selectedIndex = null;
            });
          }
        });
      } else {
        // Case 2: Tapping a different circle
        if (_selectedIndex != null) {
          final selectedIndex = _selectedIndex;
          // Collapse the previously selected circle
          final simulation = SpringSimulation(spring, 1, 0, -1);
          // ignore: discarded_futures
          _animationControllers[selectedIndex]?.animateWith(simulation).then((_) {
            if (mounted) {
              setState(() {
                _animationControllers.remove(selectedIndex);
              });
            }
          });
        }

        // Expand the newly tapped circle
        final simulation = SpringSimulation(quickOvershootSpring, 0, 1, 1);
        _animationControllers[tappedIndex] = AnimationController(
          duration: const Duration(milliseconds: 300),
          vsync: this,
        );
        _animationControllers[tappedIndex]?.animateWith(simulation);

        _selectedIndex = tappedIndex;
      }
    });
  }
}

class CircleGridPainter extends CustomPainter {
  // Controls the steepness of falloff

  CircleGridPainter({
    required this.offset,
    required this.circleSize,
    required this.selectedCircleMultiplier,
    required this.spacing,
    required this.columns,
    this.selectedIndex,
    required this.animationControllers,
  });
  final Offset offset;
  final double circleSize;
  final double selectedCircleMultiplier;
  final double spacing;
  final int? selectedIndex;
  final int columns;
  final Map<int, AnimationController> animationControllers;

  static const double maxDisplacementDistance = 6; // Maximum distance for displacement effect
  static const double fullDisplacementDistance = 0.5; // Distance for full displacement
  static const double falloffExponent = 1;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 53, 53, 53)
      ..style = PaintingStyle.fill;

    final selectedPaint = Paint()
      ..color = const Color.fromARGB(255, 186, 186, 186)
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final visibleArea = _calculateVisibleArea(size);
    final displacements = _calculateDisplacements(visibleArea);

    _drawCircles(
      canvas,
      visibleArea,
      displacements,
      paint,
      selectedPaint,
      textPainter,
    );
  }

  _VisibleArea _calculateVisibleArea(Size size) {
    return _VisibleArea(
      startCol: (-offset.dx / (circleSize + spacing)).floor() - 1,
      endCol: ((size.width - offset.dx) / (circleSize + spacing)).ceil(),
      startRow: (-offset.dy / (circleSize + spacing)).floor() - 1,
      endRow: ((size.height - offset.dy) / (circleSize + spacing)).ceil(),
    );
  }

  Map<Point<int>, Offset> _calculateDisplacements(_VisibleArea visibleArea) {
    final displacements = <Point<int>, Offset>{};
    for (final entry in animationControllers.entries) {
      final selectedIndex = entry.key;
      final animationValue = entry.value.value;

      final selectedCol = selectedIndex % columns;
      final selectedRow = selectedIndex ~/ columns;
      final expansionAmount = circleSize * (selectedCircleMultiplier - 1) / 2 * animationValue;
      final defaultSpacing = circleSize + spacing;

      for (var row = visibleArea.startRow - 2; row <= visibleArea.endRow + 2; row++) {
        for (var col = visibleArea.startCol - 2; col <= visibleArea.endCol + 2; col++) {
          if (row != selectedRow || col != selectedCol) {
            _calculateDisplacement(
              col,
              row,
              selectedCol,
              selectedRow,
              expansionAmount,
              defaultSpacing,
              displacements,
            );
          }
        }
      }
    }
    return displacements;
  }

  void _calculateDisplacement(
    int col,
    int row,
    int selectedCol,
    int selectedRow,
    double expansionAmount,
    double defaultSpacing,
    Map<Point<int>, Offset> displacements,
  ) {
    final dx = col - selectedCol;
    final dy = row - selectedRow;
    final distance = sqrt(dx * dx + dy * dy);
    final angle = atan2(dy.toDouble(), dx.toDouble());

    // Determine if the circle is diagonal or orthogonal
    final isDiagonal = dx != 0 && dy != 0;

    // Calculate the base displacement
    var displacement = _getDisplacementFixed(distance, expansionAmount, defaultSpacing);

    // diagonal adjustment
    if (isDiagonal) {
      const diagonalCorrectionFactor = 0.1; // or use 1 / sqrt(2) ≈ 0.707 for exact diagonal adjustment
      displacement *= diagonalCorrectionFactor;
    }

    if (displacement > 0) {
      final point = Point<int>(col, row);
      final newDisplacement = Offset(
        cos(angle) * displacement,
        sin(angle) * displacement,
      );

      if (displacements.containsKey(point)) {
        displacements[point] = displacements[point]! + newDisplacement;
      } else {
        displacements[point] = newDisplacement;
      }
    }
  }

  double _getDisplacementFixed(
    double distance,
    double expansionAmount,
    double defaultSpacing,
  ) {
    if (distance <= maxDisplacementDistance) {
      final falloffFactor = _calculateFalloffFactor(distance);
      return expansionAmount * falloffFactor;
    }
    return 0;
  }

  double _calculateFalloffFactor(double distance) {
    if (distance <= fullDisplacementDistance) {
      return 1;
    } else if (distance >= maxDisplacementDistance) {
      return 0;
    } else {
      final t = (distance - fullDisplacementDistance) / (maxDisplacementDistance - fullDisplacementDistance);
      return pow(1 - t, falloffExponent).toDouble();
    }
  }

  void _drawCircles(
    Canvas canvas,
    _VisibleArea visibleArea,
    Map<Point<int>, Offset> displacements,
    Paint paint,
    Paint selectedPaint,
    TextPainter textPainter,
  ) {
    for (var row = visibleArea.startRow; row <= visibleArea.endRow; row++) {
      for (var col = visibleArea.startCol; col <= visibleArea.endCol; col++) {
        final index = row * columns + col;

        var circleOffset = Offset(
          col * (circleSize + spacing) + offset.dx,
          row * (circleSize + spacing) + offset.dy,
        );

        if (displacements.containsKey(Point(col, row))) {
          circleOffset += displacements[Point(col, row)]!;
        }

        var currentCircleSize = circleSize;
        var currentPaint = paint;

        if (animationControllers.containsKey(index)) {
          final animationValue = animationControllers[index]?.value ?? 0.0;
          currentCircleSize += circleSize * (selectedCircleMultiplier - 1) * animationValue;
          currentPaint = Paint()
            ..color = Color.lerp(paint.color, selectedPaint.color, animationValue)!
            ..style = PaintingStyle.fill;
        }

        canvas.drawCircle(
          circleOffset,
          currentCircleSize / 2,
          currentPaint,
        );
      }
    }
  }

  Color lerpColor(Color a, Color b, double t) {
    return Color.lerp(a, b, t)!;
  }

  //Optimize this for better performance
  @override
  bool shouldRepaint(covariant CircleGridPainter oldDelegate) => true;
}

class _VisibleArea {
  _VisibleArea({
    required this.startCol,
    required this.endCol,
    required this.startRow,
    required this.endRow,
  });
  final int startCol;
  final int endCol;
  final int startRow;
  final int endRow;
}

class DebugPainter extends CustomPainter {
  DebugPainter({
    this.tapPosition,
    required this.gridOffset,
    required this.circleSize,
    required this.spacing,
    required this.columns,
  });
  final Offset? tapPosition;
  final Offset gridOffset;
  final double circleSize;
  final double spacing;
  final int columns;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw tap position
    if (tapPosition != null) {
      canvas.drawCircle(tapPosition!, 5, paint..style = PaintingStyle.fill);

      // Draw crosshair
      canvas.drawLine(
        Offset(tapPosition!.dx - 10, tapPosition!.dy),
        Offset(tapPosition!.dx + 10, tapPosition!.dy),
        paint..style = PaintingStyle.stroke,
      );
      canvas.drawLine(
        Offset(tapPosition!.dx, tapPosition!.dy - 10),
        Offset(tapPosition!.dx, tapPosition!.dy + 10),
        paint,
      );

      // Calculate and draw the grid cell
      final col = ((tapPosition!.dx - gridOffset.dx + circleSize / 2) / (circleSize + spacing)).floor();
      final row = ((tapPosition!.dy - gridOffset.dy + circleSize / 2) / (circleSize + spacing)).floor();

      final cellRect = Rect.fromLTWH(
        gridOffset.dx + (col - 0.5) * (circleSize + spacing),
        gridOffset.dy + (row - 0.5) * (circleSize + spacing),
        circleSize + spacing,
        circleSize + spacing,
      );
      canvas.drawRect(cellRect, paint..color = Colors.green);

      // Draw text for coordinates and calculated index
      final textPainter = TextPainter(
        text: TextSpan(
          text: 'Tap: (${tapPosition!.dx.toStringAsFixed(1)}, ${tapPosition!.dy.toStringAsFixed(1)})\n'
              'Cell: ($col, $row)\n'
              'Index: ${row * columns + col}',
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, const Offset(10, 10));
    }
  }

  @override
  bool shouldRepaint(covariant DebugPainter oldDelegate) {
    return tapPosition != oldDelegate.tapPosition || gridOffset != oldDelegate.gridOffset;
  }
}
