import 'dart:math' as math;

import 'package:flutter/material.dart';

class WaveWarpEffect extends StatefulWidget {
  const WaveWarpEffect({
    super.key,
    required this.child,
    this.waveHeight = 20.0,
    this.waveWidth = 100.0,
    this.speed = 1.0,
    this.phase = 0.0,
  });
  final Widget child;
  final double waveHeight;
  final double waveWidth;
  final double speed;
  final double phase;

  @override
  _WaveWarpEffectState createState() => _WaveWarpEffectState();
}

class _WaveWarpEffectState extends State<WaveWarpEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: (5 / widget.speed).round()),
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
        return ClipPath(
          clipper: WaveClipper(
            animationValue: _controller.value,
            waveHeight: widget.waveHeight,
            waveWidth: widget.waveWidth,
            phase: widget.phase,
          ),
          child: widget.child,
        );
      },
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  WaveClipper({
    required this.animationValue,
    required this.waveHeight,
    required this.waveWidth,
    required this.phase,
  });
  final double animationValue;
  final double waveHeight;
  final double waveWidth;
  final double phase;

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);

    // Create wave effect
    for (double x = 0; x < size.width; x++) {
      final y = waveHeight *
          math.sin(
            (x / waveWidth) * 2 * math.pi + (animationValue * 2 * math.pi) + phase,
          );

      path.lineTo(x, y);
    }

    // Complete the path
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) => animationValue != oldClipper.animationValue;
}

// Usage Example:
class WaveWarpDemo extends StatelessWidget {
  const WaveWarpDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: WaveWarpEffect(
          child: Container(
            width: 300,
            height: 200,
            color: Colors.blue,
            child: const Center(
              child: Text(
                'Wave Warp Effect',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
