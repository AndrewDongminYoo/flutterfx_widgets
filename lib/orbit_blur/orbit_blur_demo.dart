import 'package:flutter/material.dart';

import 'package:flutterfx_widgets/orbit_blur/orbit_blur.dart';

class OrbitExtendedDemo extends StatelessWidget {
  const OrbitExtendedDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: OrbitingIconsWithControls(),
        ),
      ),
    );
  }
}
