import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class FractalGlassEffect extends StatefulWidget {
  const FractalGlassEffect({
    super.key,
    required this.imageProvider,
  });

  final ImageProvider imageProvider;

  @override
  State<FractalGlassEffect> createState() => _FractalGlassEffectState();
}

class _FractalGlassEffectState extends State<FractalGlassEffect> {
  double _turbulence = 0.05;
  double _scale = 10;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Fractal Glass Effect Image
        CustomPaint(
          painter: FractalGlassPainter(
            image: widget.imageProvider,
            turbulence: _turbulence,
            scale: _scale,
          ),
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(),
          ),
        ),

        // Turbulence Slider
        _buildSlider(
          label: 'Turbulence Intensity',
          value: _turbulence,
          min: 0.01,
          max: 0.2,
          onChanged: (value) {
            setState(() {
              _turbulence = value;
            });
          },
        ),

        // Scale Slider
        _buildSlider(
          label: 'Distortion Scale',
          value: _scale,
          min: 0,
          max: 50,
          onChanged: (value) {
            setState(() {
              _scale = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ${value.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: 50,
            label: value.toStringAsFixed(2),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class FractalGlassPainter extends CustomPainter {
  FractalGlassPainter({
    required this.image,
    this.turbulence = 0.05,
    this.scale = 10.0,
  });

  final ImageProvider image;
  final double turbulence;
  final double scale;
  ui.Image? _cachedImage;

  Future<void> _loadImage() async {
    final completer = Completer<ui.Image>();
    final stream = image.resolve(ImageConfiguration.empty);

    stream.addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(info.image);
      }),
    );

    _cachedImage = await completer.future;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_cachedImage == null) {
      // Trigger image loading if not already loaded
      // ignore: discarded_futures
      _loadImage();
      return;
    }

    // Draw the original image
    final paint = Paint();
    canvas.drawImage(_cachedImage!, Offset.zero, paint);

    // Create a shader for the fractal distortion effect
    final shader = _createFractalShader(size, _cachedImage!);

    // Apply the distortion shader
    final distortPaint = Paint()
      ..shader = shader
      ..blendMode = BlendMode.srcOver;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      distortPaint,
    );
  }

  Shader _createFractalShader(Size size, ui.Image image) {
    // Generate random transformations for a fractal-like effect
    final random = math.Random();

    // Create a matrix with noise-based transformations
    final matrix = Matrix4.identity()
      ..translate(
        (random.nextDouble() * 2 - 1) * turbulence * size.width * scale,
        (random.nextDouble() * 2 - 1) * turbulence * size.height * scale,
      )
      ..rotateZ(random.nextDouble() * turbulence * scale);

    // Create an image shader with the transformation
    return ImageShader(
      image,
      TileMode.repeated,
      TileMode.repeated,
      matrix.storage,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class FractalGlassDemo extends StatelessWidget {
  const FractalGlassDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: FractalGlassEffect(
          imageProvider: NetworkImage(
            'https://plus.unsplash.com/premium_photo-1689568158814-3b8e9c1a9618',
          ),
        ),
      ),
    );
  }
}
