import 'package:flutter/material.dart';

import 'package:fx_2_folder/loader-sphere/grid.dart';
import 'package:fx_2_folder/loader-sphere/loader_sphere.dart';

class LoaderSphereDemo extends StatefulWidget {
  const LoaderSphereDemo({super.key});

  @override
  State<LoaderSphereDemo> createState() => _LoaderSphereDemoState();
}

class _LoaderSphereDemoState extends State<LoaderSphereDemo> {
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
          Center(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 120,
                maxHeight: 120,
              ),
              child: const RippleDemo(),
            ),
          ),
        ],
      ),
    );
  }
}

class RippleDemo extends StatelessWidget {
  const RippleDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9), // Slightly transparent background
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 30,
            spreadRadius: 5,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 40,
            spreadRadius: 10,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: const Center(
        child: AnimatedWaveRipple(
          size: 120,
          opacity: 0.6,
        ),
      ),
    );
  }
}
