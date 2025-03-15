import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class BorderBeamsBackground extends StatelessWidget {
  const BorderBeamsBackground({
    super.key,
    this.numberOfSimultaneousBeams = 10,
  });

  final int numberOfSimultaneousBeams;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          BackgroundBeams(numberOfBeams: numberOfSimultaneousBeams),
          const SafeArea(
            child: Center(
              child: Text(
                'Background Beams!',
                style: TextStyle(color: Colors.white, fontSize: 34),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BeamAnimation {
  BeamAnimation({
    required this.beamIndex,
    required this.controller,
    required this.startTime,
  });

  final int beamIndex;
  final AnimationController controller;
  final DateTime startTime;
}

class BackgroundBeams extends StatefulWidget {
  const BackgroundBeams({
    super.key,
    required this.numberOfBeams,
  });

  final int numberOfBeams;

  @override
  State<BackgroundBeams> createState() => _BackgroundBeamsState();
}

class _BackgroundBeamsState extends State<BackgroundBeams> with TickerProviderStateMixin {
  final List<BeamAnimation> _activeBeams = [];
  final Random random = Random();
  Timer? _spawnTimer;

  @override
  void initState() {
    super.initState();
    _startSpawning();
  }

  void _startSpawning() {
    // Initially spawn first beam
    _spawnBeam();

    // Set up timer to check and spawn new beams
    _spawnTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      _checkAndSpawnBeams();
    });
  }

  void _checkAndSpawnBeams() {
    // Remove completed animations
    _activeBeams.removeWhere((beam) => !beam.controller.isAnimating);

    // If we have room for more beams, spawn a new one with random delay
    if (_activeBeams.length < widget.numberOfBeams) {
      // Add random delay between 0-1000ms to prevent simultaneous starts
      Future.delayed(
        Duration(milliseconds: random.nextInt(1000)),
        _spawnBeam,
      );
    }
  }

  void _spawnBeam() {
    if (_activeBeams.length >= widget.numberOfBeams) {
      return;
    }

    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    final beamIndex = random.nextInt(25); // Total number of beam paths

    final beam = BeamAnimation(
      beamIndex: beamIndex,
      controller: controller,
      startTime: DateTime.now(),
    );

    setState(() {
      _activeBeams.add(beam);
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
        setState(() {
          _activeBeams.remove(beam);
        });
      }
    });

    controller.forward();
  }

  @override
  void dispose() {
    _spawnTimer?.cancel();
    for (final beam in _activeBeams) {
      beam.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: Listenable.merge(
              _activeBeams.map((beam) => beam.controller).toList(),
            ),
            builder: (context, child) {
              return CustomPaint(
                painter: BeamsPainter(
                  activeBeams: _activeBeams,
                ),
                size: Size.infinite,
              );
            },
          ),
        ],
      ),
    );
  }
}

class BeamsPainter extends CustomPainter {
  BeamsPainter({
    required this.activeBeams,
  });

  final List<BeamAnimation> activeBeams;

  List<Path> getBeamPaths(Size size) {
    const numberOfBeams = 25;
    const beamPadding = 50.0;

    // Add extra width padding to ensure coverage on edges
    final extraWidth = size.width * 0.1; // 10% extra width on each side
    final totalWidth = size.width + (extraWidth * 2);
    final availableHeight = size.height - (beamPadding * 2);

    // Calculate spacing using expanded width
    final spacing = totalWidth / (numberOfBeams - 1);

    return List.generate(numberOfBeams, (index) {
      // Shift startX left by extraWidth to start before viewport
      final startX = (spacing * index) - extraWidth;
      final path = Path();

      path.moveTo(startX, -beamPadding);

      final horizontalOffset = size.width * 0.3;

      path.cubicTo(
        startX + horizontalOffset,
        availableHeight * 0.3 + beamPadding,
        startX - horizontalOffset,
        availableHeight * 0.7 + beamPadding,
        startX,
        size.height + beamPadding,
      );

      return path;
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    final beamPaths = getBeamPaths(size);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // Draw base paths with lower opacity
    paint.shader = ui.Gradient.linear(
      Offset.zero,
      Offset(size.width, size.height),
      [
        Colors.grey.withValues(alpha: 0.25),
        Colors.grey.withValues(alpha: 0.25),
      ],
    );

    for (final path in beamPaths) {
      canvas.drawPath(path, paint);
    }

    // Draw each active beam
    for (final beam in activeBeams) {
      final selectedPath = beamPaths[beam.beamIndex];
      final pathMetrics = selectedPath.computeMetrics().single;
      final pathLength = pathMetrics.length;

      final start = beam.controller.value * pathLength;
      final end = (start + pathLength / 10) % pathLength;

      Path shootingStarPath;
      if (end > start) {
        shootingStarPath = pathMetrics.extractPath(start, end);
      } else {
        shootingStarPath = pathMetrics.extractPath(start, pathLength);
        shootingStarPath.addPath(pathMetrics.extractPath(0, end), Offset.zero);
      }

      //random number between 12 and 18
      final pathSegmentLength = pathLength / (12 + Random().nextInt(6)); // Add this line
      final gradientPosition = pathMetrics.getTangentForOffset(start);
      if (gradientPosition != null) {
        final gradientStart = gradientPosition.position;
        final gradientEnd =
            pathMetrics.getTangentForOffset(start + pathSegmentLength)?.position ?? gradientPosition.position;

        final shootingStarPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..isAntiAlias = true
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..filterQuality = FilterQuality.high
          ..shader = ui.Gradient.linear(
            gradientStart,
            gradientEnd,
            [
              const Color(0xFFAE48FF).withValues(alpha: 0), // Transparent start
              // const Color.fromARGB(255, 79, 41, 250), // Deep blue
              // const Color.fromARGB(255, 107, 75, 253), // Medium blue
              // const Color.fromARGB(255, 107, 75, 253), // Cyan
              const Color.fromARGB(255, 0, 200, 255),
            ],
            [0.0, 1.0],
          );

        canvas.drawPath(shootingStarPath, shootingStarPaint);
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant BeamsPainter oldDelegate) {
    return true;
  }
}

class BeamPath {
  BeamPath({
    required this.startX,
    required this.startY,
    required this.controlX,
    required this.controlY,
    required this.endX,
    required this.endY,
  });

  final double startX;
  final double startY;
  final double controlX;
  final double controlY;
  final double endX;
  final double endY;
}
