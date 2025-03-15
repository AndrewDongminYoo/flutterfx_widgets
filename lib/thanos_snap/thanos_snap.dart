import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_shaders/flutter_shaders.dart';

class ThanosSnapEffect extends StatefulWidget {
  const ThanosSnapEffect({
    super.key,
    required this.child,
    this.onComplete,
    this.duration = const Duration(milliseconds: 1000),
  });

  final Widget child;
  final VoidCallback? onComplete;
  final Duration duration;

  @override
  ThanosSnapEffectState createState() => ThanosSnapEffectState();
}

class ThanosSnapEffectState extends State<ThanosSnapEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  ui.Image? _capturedImage;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onComplete?.call();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _captureWidget() async {
    final boundary = context.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage();
    setState(() {
      _capturedImage = image;
    });
  }

  Future<void> snap() async {
    await _captureWidget();
    await _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: _capturedImage == null
          ? widget.child
          : ShaderBuilder(
              assetKey: 'shaders/thanos_effect.frag',
              (context, shader, child) {
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    shader
                      ..setFloat(0, _controller.value) // iTime
                      ..setFloat(1, _controller.value * 2.0) // dissolveScale
                      ..setFloat(2, MediaQuery.of(context).size.width) // iResolution
                      ..setFloat(3, MediaQuery.of(context).size.height) // iResolution
                      ..setImageSampler(0, _capturedImage!); // iImage

                    return CustomPaint(
                      painter: ShaderPainter(shader),
                      size: MediaQuery.of(context).size,
                    );
                  },
                );
              },
            ),
    );
  }
}

class ShaderPainter extends CustomPainter {
  ShaderPainter(this.shader);

  final ui.FragmentShader shader;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
