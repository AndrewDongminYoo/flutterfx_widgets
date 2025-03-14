import 'package:flutter/material.dart';

import 'package:fx_2_folder/text_3d_pop/text_3d_pop.dart';

class Text3dPopDemo extends StatelessWidget {
  const Text3dPopDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Gyro3DText(
          text: 'FLUTTER',
          fontSize: 52,
          textColor: Color.fromARGB(255, 255, 232, 120), // f08c02
          shadowColor: Color.fromARGB(255, 240, 140, 2),
          maxTiltAngle: 30,
          shadowSensitivity: 0.1, // Reduced for smoother movement
        ),
      ),
    );
  }
}
