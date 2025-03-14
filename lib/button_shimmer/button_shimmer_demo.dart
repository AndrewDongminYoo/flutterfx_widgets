import 'package:flutter/material.dart';

import 'package:flutterfx_widgets/button_shimmer/button_shimmer.dart';
import 'package:flutterfx_widgets/stacked_expand_cards/stacked_expand_card.dart';

class ButtonShimmerDemo extends StatefulWidget {
  const ButtonShimmerDemo({super.key});

  @override
  State<ButtonShimmerDemo> createState() => _ParticlesDemoState();
}

class _ParticlesDemoState extends State<ButtonShimmerDemo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: double.infinity,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: GridPatternPainter(isDarkMode: true),
              ),
            ),
            ShimmerButton(
              onPressed: () {
                // Handle tap
                debugPrint('onPressed');
              },
              shimmerColorFrom: const Color.fromARGB(255, 255, 255, 255), // Orange
              shimmerColorTo: const Color.fromARGB(255, 255, 255, 255), // Purple
              child: const Text(
                'Click Me',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
