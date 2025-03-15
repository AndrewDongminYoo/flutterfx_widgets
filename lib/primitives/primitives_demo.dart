import 'package:flutter/material.dart';

import 'package:fx_2_folder/primitives/primitives.dart';

class MotionPrimitiveDemo extends StatefulWidget {
  const MotionPrimitiveDemo({super.key});

  @override
  State<MotionPrimitiveDemo> createState() => _DemoState();
}

class _DemoState extends State<MotionPrimitiveDemo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: double.infinity,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: const Stack(
          children: [
            Positioned.fill(
              child: MotionDemo(),
            ),
          ],
        ),
      ),
    );
  }
}
