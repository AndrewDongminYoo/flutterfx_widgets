import 'package:flutter/material.dart';

import 'package:flutterfx_widgets/fx_11_typing_animation/typing_anim.dart';

class TypingAnimationDemo extends StatefulWidget {
  const TypingAnimationDemo({super.key});

  @override
  State<TypingAnimationDemo> createState() => _TypingAnimationDemoState();
}

class _TypingAnimationDemoState extends State<TypingAnimationDemo> {
  bool _animate = false;

  void _toggleAnimation() {
    setState(() {
      _animate = !_animate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TypingAnimation(
              text: 'Typing Animation',
              animate: _animate,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleAnimation,
              child: Text(_animate ? 'Stop Animation' : 'Start Animation'),
            ),
          ],
        ),
      ),
    );
  }
}
