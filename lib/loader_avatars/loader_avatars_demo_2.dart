import 'dart:math';

import 'package:flutter/material.dart';

import 'package:fx_2_folder/loader_avatars/design/grid.dart';
import 'package:fx_2_folder/loader_avatars/loader_avatars.dart';
import 'package:fx_2_folder/loader_avatars/strategies/coin_flip_strategy.dart';

class LoaderAvatarsDemo2 extends StatelessWidget {
  const LoaderAvatarsDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: GridPatternPainter(isDarkMode: true),
            size: Size.infinite,
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _DemoSection(
                    title: 'Coin',
                    child: AnimatedAvatarRow(
                      numberOfAvatars: 8,
                      animationStrategy: CoinFlipStrategy(),
                      avatarSize: 32,
                      overlapFactor: 0.4,
                    ),
                  ),

                  const SizedBox(height: 32),

                  _DemoSection(
                    title: 'Rotate',
                    child: AnimatedAvatarRow(
                      numberOfAvatars: 8,
                      animationStrategy: CoinRotateStrategy(),
                      avatarSize: 32,
                      overlapFactor: 0.5,
                    ),
                  ),

                  const SizedBox(height: 32),

                  _DemoSection(
                    title: 'Rotate X',
                    child: AnimatedAvatarRow(
                      numberOfAvatars: 8,
                      animationStrategy: CoinRotateXStrategy(
                        staggerDelay: const Duration(milliseconds: 80),
                      ),
                      avatarSize: 32,
                      overlapFactor: 0.5,
                    ),
                  ),

                  const SizedBox(height: 32),

                  _DemoSection(
                    title: 'Rotate Y',
                    child: AnimatedAvatarRow(
                      numberOfAvatars: 8,
                      animationStrategy: CoinRotateYStrategy(
                        staggerDelay: const Duration(milliseconds: 80),
                      ),
                      avatarSize: 32,
                      overlapFactor: 0.5,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Random chaotic movement
                  _DemoSection(
                    title: 'Breathing Space',
                    child: AnimatedAvatarRow(
                      numberOfAvatars: 8,
                      animationStrategy: BreathingSpaceStrategy(
                        maxScale: 1.15,
                        maxDistance: 15,
                      ),
                      avatarSize: 32,
                      overlapFactor: 0.45,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Random chaotic movement
                  _DemoSection(
                    title: 'Zen ripple',
                    child: AnimatedAvatarRow(
                      numberOfAvatars: 8,
                      animationStrategy: ZenRippleStrategy(
                        maxRotation: pi / 6,
                        maxTranslation: 20,
                      ),
                      avatarSize: 32,
                      overlapFactor: 0.35,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Random chaotic movement
                  _DemoSection(
                    title: 'Floating Meditation',
                    child: AnimatedAvatarRow(
                      numberOfAvatars: 8,
                      animationStrategy: FloatingMeditationStrategy(
                        floatHeight: 15,
                        rotationAngle: pi / 10,
                      ),
                      avatarSize: 32,
                      overlapFactor: 0.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget to display a demo section with title and description
class _DemoSection extends StatelessWidget {
  const _DemoSection({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        child,
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
