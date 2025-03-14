import 'package:flutter/material.dart';

import 'package:fx_2_folder/celebrate/celebrate.dart';

class CelebrateHomeWidget extends StatelessWidget {
  const CelebrateHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Or any other positioning widget
        child: CoolMode(
          particleImage: 'your_image_url',
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('LONG PRESS!'),
          ),
        ),
      ),
    );
  }
}
