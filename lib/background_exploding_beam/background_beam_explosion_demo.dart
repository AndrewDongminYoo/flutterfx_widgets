import 'package:flutter/material.dart';

import 'package:fx_2_folder/background_exploding_beam/background_beam_explosion.dart';

class ExplodingBeamDemo extends StatefulWidget {
  const ExplodingBeamDemo({super.key});

  @override
  State<ExplodingBeamDemo> createState() => _DemoState();
}

class _DemoState extends State<ExplodingBeamDemo> {
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
              child: BackgroundBeamsWithCollision(
                child: Text(
                  'Exploding Beam!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                  ),
                ), // Optional child widget
              ),
            ),
          ],
        ),
      ),
    );
  }
}
