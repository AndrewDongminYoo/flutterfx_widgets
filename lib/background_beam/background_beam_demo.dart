import 'package:flutter/material.dart';

import 'package:flutterfx_widgets/background_beam/background_beam.dart';

class BackgroundBeamDemo extends StatefulWidget {
  const BackgroundBeamDemo({super.key});

  @override
  State<BackgroundBeamDemo> createState() => _DemoState();
}

class _DemoState extends State<BackgroundBeamDemo> {
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
              child: BorderBeamsBackground(),
            ),
          ],
        ),
      ),
    );
  }
}
