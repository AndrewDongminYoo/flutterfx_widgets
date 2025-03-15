import 'package:flutter/material.dart';

import 'package:fx_2_folder/loader_avatars/design/grid.dart';
import 'package:fx_2_folder/loader_avatars/loader_avatars.dart';
import 'package:fx_2_folder/loader_avatars/strategies/loader_strategy_pulse.dart';
import 'package:fx_2_folder/loader_avatars/strategies/loader_strategy_random.dart';
import 'package:fx_2_folder/loader_avatars/strategies/loader_strategy_ripple.dart';
import 'package:fx_2_folder/loader_avatars/strategies/loader_strategy_wave.dart';

class LoaderAvatarsDemo extends StatelessWidget {
  const LoaderAvatarsDemo({super.key});

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
                    title: 'Pulse',
                    child: AnimatedAvatarRow(
                      numberOfAvatars: 8,
                      animationStrategy: PulseAnimationStrategy(
                        scaleAmount: 0.6,
                        waveWidth: 0.1,
                        phaseShiftFactor: 0.6,
                      ),
                      avatarSize: 32,
                      overlapFactor: 0.4,
                    ),
                  ),

                  const SizedBox(height: 32),

                  _DemoSection(
                    title: 'Wave',
                    child: AnimatedAvatarRow(
                      numberOfAvatars: 6,
                      animationStrategy: WaveAnimationStrategy(),
                      avatarSize: 32,
                      overlapFactor: 0.3,
                    ),
                  ),

                  const SizedBox(height: 32),
                  _DemoSection(
                    title: 'Ripple',
                    child: AnimatedAvatarRow(
                      numberOfAvatars: 8,
                      animationStrategy: RippleAnimationStrategy(),
                      avatarSize: 32,
                      overlapFactor: 0.4,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Random chaotic movement
                  _DemoSection(
                    title: 'Random',
                    child: AnimatedAvatarRow(
                      numberOfAvatars: 8,
                      animationStrategy: RandomAnimationStrategy(),
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
