import 'dart:math';

import 'package:flutter/material.dart';

class TextOnPathEditor extends StatefulWidget {
  const TextOnPathEditor({super.key});

  @override
  State<TextOnPathEditor> createState() => _TextOnPathEditorState();
}

class _TextOnPathEditorState extends State<TextOnPathEditor> {
  // Text properties
  String text = 'TEXT ON PATH';
  double fontSize = 52;
  double spread = 1;
  double magnify = 1;

  // Control points
  List<Offset> controlPoints = [
    const Offset(100, 200),
    const Offset(200, 100),
    const Offset(300, 300),
    const Offset(400, 200),
  ];

  int? selectedPointIndex;

  // Text editing controller
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: text);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          _buildControlPanel(),
          Expanded(
            child: _buildDrawingArea(),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.white12,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text Input
          TextField(
            controller: textController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Text on Path',
              labelStyle: const TextStyle(color: Colors.white),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear, color: Colors.white),
                onPressed: () => textController.clear(),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            onChanged: (value) {
              setState(() {
                text = value;
              });
            },
          ),
          const SizedBox(height: 16),

          // Font Size Slider
          _buildSliderControl(
            label: 'Font size',
            value: fontSize,
            min: 12,
            max: 100,
            onChanged: (value) {
              setState(() {
                fontSize = value;
              });
            },
          ),

          // Spread Slider
          _buildSliderControl(
            label: 'Spread',
            value: spread,
            min: 0.5,
            max: 2,
            onChanged: (value) {
              setState(() {
                spread = value;
              });
            },
          ),

          // Magnify Slider
          _buildSliderControl(
            label: 'Magnify',
            value: magnify,
            min: 0.5,
            max: 2,
            onChanged: (value) {
              setState(() {
                magnify = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSliderControl({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white)),
            Text(
              value.toStringAsFixed(1),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.white24,
            thumbColor: Colors.white,
            overlayColor: Colors.white.withValues(alpha: 0.1),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildDrawingArea() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onPanDown: (details) => _handlePanDown(details, constraints),
          onPanUpdate: _handlePanUpdate,
          onPanEnd: _handlePanEnd,
          child: CustomPaint(
            size: Size(constraints.maxWidth, constraints.maxHeight),
            painter: TextOnPathPainter(
              text: text,
              fontSize: fontSize,
              spread: spread,
              magnify: magnify,
              controlPoints: controlPoints,
              selectedPointIndex: selectedPointIndex,
            ),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        );
      },
    );
  }

  void _handlePanDown(DragDownDetails details, BoxConstraints constraints) {
    final localPosition = details.localPosition;

    for (var i = 0; i < controlPoints.length; i++) {
      if ((localPosition - controlPoints[i]).distance < 20) {
        setState(() {
          selectedPointIndex = i;
        });
        break;
      }
    }
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (selectedPointIndex != null) {
      setState(() {
        controlPoints[selectedPointIndex!] += details.delta;
      });
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    setState(() {
      selectedPointIndex = null;
    });
  }
}

class TextOnPathPainter extends CustomPainter {
  TextOnPathPainter({
    required this.text,
    required this.fontSize,
    required this.spread,
    required this.magnify,
    required this.controlPoints,
    this.selectedPointIndex,
  });
  final String text;
  final double fontSize;
  final double spread;
  final double magnify;
  final List<Offset> controlPoints;
  final int? selectedPointIndex;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the path and control points
    _drawPath(canvas);
    _drawControlPoints(canvas);
    _drawControlLines(canvas);

    // Draw the text on path
    _drawTextOnPath(canvas);
  }

  void _drawPath(Canvas canvas) {
    final path = Path();
    path.moveTo(controlPoints[0].dx, controlPoints[0].dy);
    path.cubicTo(
      controlPoints[1].dx,
      controlPoints[1].dy,
      controlPoints[2].dx,
      controlPoints[2].dy,
      controlPoints[3].dx,
      controlPoints[3].dy,
    );

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawPath(path, paint);
  }

  void _drawControlPoints(Canvas canvas) {
    for (var i = 0; i < controlPoints.length; i++) {
      final paint = Paint()
        ..color = i == selectedPointIndex ? Colors.white : Colors.white70
        ..style = PaintingStyle.fill;

      canvas.drawCircle(controlPoints[i], 8, paint);
    }
  }

  void _drawControlLines(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawLine(controlPoints[0], controlPoints[1], paint);
    canvas.drawLine(controlPoints[2], controlPoints[3], paint);
  }

  void _drawTextOnPath(Canvas canvas) {
    final path = Path();
    path.moveTo(controlPoints[0].dx, controlPoints[0].dy);
    path.cubicTo(
      controlPoints[1].dx,
      controlPoints[1].dy,
      controlPoints[2].dx,
      controlPoints[2].dy,
      controlPoints[3].dx,
      controlPoints[3].dy,
    );

    final pathMetric = path.computeMetrics().first;
    final pathLength = pathMetric.length;

    final textStyle = TextStyle(
      fontSize: fontSize * magnify,
      color: Colors.white,
    );

    final textSpan = TextSpan(text: 'A', style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final charWidth = textPainter.width * spread;
    final totalTextLength = charWidth * text.length;

    var startOffset = (pathLength - totalTextLength) / 2;
    if (startOffset < 0) {
      startOffset = 0;
    }

    for (var i = 0; i < text.length; i++) {
      final charOffset = startOffset + (i * charWidth);
      if (charOffset > pathLength) {
        break;
      }

      final tangent = pathMetric.getTangentForOffset(charOffset);
      if (tangent == null) {
        continue;
      }

      final charTextPainter = TextPainter(
        text: TextSpan(
          text: text[i],
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      );
      charTextPainter.layout();

      canvas.save();

      final angle = atan2(tangent.vector.dy, tangent.vector.dx);
      final position = tangent.position;
      canvas.translate(position.dx, position.dy);
      canvas.rotate(angle);

      charTextPainter.paint(
        canvas,
        Offset(
          -charTextPainter.width / 2,
          -charTextPainter.height,
        ),
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
