import 'package:flutter/material.dart';

import 'package:flutterfx_widgets/slider/slider.dart';

class SliderDemo extends StatefulWidget {
  const SliderDemo({super.key});

  @override
  State<SliderDemo> createState() => _DemoState();
}

class _DemoState extends State<SliderDemo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: double.infinity,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Positioned.fill(
              child: WorkLifeSlider(
                onChanged: (newValue) {
                  debugPrint('New work-life balance: $newValue%');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
