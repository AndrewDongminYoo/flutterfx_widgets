import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class NeonCard extends StatefulWidget {
  const NeonCard({
    super.key,
    required this.child,
    this.intensity = 0.3,
    this.glowSpread = 2.0,
  });

  final Widget child;
  final double intensity;
  final double glowSpread;

  @override
  NeonCardState createState() => NeonCardState();
}

class NeonCardState extends State<NeonCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
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
          painter: GlowRectanglePainter(
            progress: _controller.value,
            intensity: widget.intensity,
            glowSpread: widget.glowSpread,
          ),
          child: widget.child,
        );
      },
    );
  }
}

class GlowRectanglePainter extends CustomPainter {
  GlowRectanglePainter({
    required this.progress,
    this.intensity = 0.3,
    this.glowSpread = 2.0,
  });

  final double progress;
  final double intensity;
  final double glowSpread;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(12));

    const firstColor = Color(0xFFFF00AA);
    const secondColor = Color(0xFF00FFF1);
    const blurSigma = 50.0;

    final backgroundPaint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(size.width / 2, size.height / 2),
        size.width * glowSpread,
        [
          Color.lerp(firstColor, secondColor, progress)!.withValues(alpha: intensity),
          Color.lerp(firstColor, secondColor, progress)!.withValues(alpha: 0),
        ],
      )
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, blurSigma);
    canvas.drawRect(rect.inflate(size.width * glowSpread), backgroundPaint);

    final blackPaint = Paint()..color = Colors.black;
    canvas.drawRRect(rrect, blackPaint);

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..shader = LinearGradient(
        colors: [
          Color.lerp(firstColor, secondColor, progress)!,
          Color.lerp(secondColor, firstColor, progress)!,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);

    canvas.drawRRect(rrect, glowPaint);
  }

  @override
  bool shouldRepaint(GlowRectanglePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.intensity != intensity || oldDelegate.glowSpread != glowSpread;
}
