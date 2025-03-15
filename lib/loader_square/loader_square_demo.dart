import 'package:flutter/material.dart';

import 'package:flutterfx_widgets/loader_sphere/grid.dart';
import 'package:flutterfx_widgets/loader_square/loader_square.dart';

class LoaderSquareDemo extends StatefulWidget {
  const LoaderSquareDemo({super.key});

  @override
  State<LoaderSquareDemo> createState() => _LoaderSphereDemoState();
}

class _LoaderSphereDemoState extends State<LoaderSquareDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Make scaffold background transparent
      body: Stack(
        fit: StackFit.expand, // Make stack fill the available space
        children: [
          // Grid background
          CustomPaint(
            painter: GridPatternPainter(isDarkMode: false),
            size: Size.infinite,
          ),
          // Centered demo widget
          const Center(
            child: BouncingSquare(),
          ),
        ],
      ),
    );
  }
}
