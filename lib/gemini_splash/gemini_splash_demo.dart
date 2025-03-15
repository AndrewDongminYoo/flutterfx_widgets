import 'package:flutter/material.dart';

import 'package:flutterfx_widgets/gemini_splash/combined_.dart';
import 'package:flutterfx_widgets/gemini_splash/glowing_fog.dart';

class SparkleDemo extends StatefulWidget {
  const SparkleDemo({super.key});

  @override
  State<SparkleDemo> createState() => _SparkleDemoState();
}

class _SparkleDemoState extends State<SparkleDemo> {
  Key _combinedKey = UniqueKey();

  final GlobalKey<MysticalWavesState> _wavesKey = GlobalKey();

  void _replayAnimation() {
    setState(() async {
      _combinedKey = UniqueKey();
      await _wavesKey.currentState?.stopAnimation();
    });
  }

  Future<void> _onStarAnimationComplete() async {
    // Start waves animation when star animation completes
    await _wavesKey.currentState?.startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          UnifiedStarAnimation(
            key: _combinedKey,
            color: Colors.yellow,
            totalDuration: const Duration(milliseconds: 2000),
            onAnimationComplete: _onStarAnimationComplete,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: MysticalWaves(
              key: _wavesKey,
              animationDuration: const Duration(milliseconds: 400),
              waveColors: [
                const Color(0xFFFFD700).withValues(alpha: 0.5), // Radiant gold
                const Color(0xFFFFA500).withValues(alpha: 0.4), // Glowing orange
                const Color(0xFFFFE4B5).withValues(alpha: 0.3), // Soft moccasin
              ],
            ),
          ),
          Positioned(
            bottom: 50,
            child: Row(
              children: [
                IconButton(
                  onPressed: _replayAnimation,
                  icon: const Icon(
                    Icons.replay_circle_filled_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
