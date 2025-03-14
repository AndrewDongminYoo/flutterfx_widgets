import 'package:flutter/material.dart';

import 'package:fx_2_folder/progress-bar/design/grid.dart';
import 'package:fx_2_folder/progress-bar/progress_bar.dart';
import 'package:fx_2_folder/progress-bar/strategies/clock_progress_strategy.dart';
import 'package:fx_2_folder/progress-bar/strategies/snow_progres_strategy.dart';
import 'package:fx_2_folder/progress-bar/strategies/typing_progress_strategy.dart';

class ProgressBarDemo2 extends StatefulWidget {
  const ProgressBarDemo2({super.key});

  @override
  State<ProgressBarDemo2> createState() => _ProgressBarDemo2State();
}

class _ProgressBarDemo2State extends State<ProgressBarDemo2> {
  // Current progress value
  double _progress = 0.7;

  // Define consistent color palette
  static const Color _primaryWhite = Color(0xFFFFFFFF);
  static const Color _softWhite = Color(0xFFE0E0E0);
  static const Color _mediumGray = Color(0xFF808080);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Grid background with darker shade
          CustomPaint(
            painter: GridPatternPainter(
              isDarkMode: true,
            ),
            size: Size.infinite,
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                ProgressLoader(
                  progress: _progress,
                  strategy: TypingProgressStrategy(),
                  style: ProgressStyle(
                    height: 48,
                    primaryColor: Colors.black87,
                    backgroundColor: Colors.grey[200]!,
                    borderRadius: BorderRadius.circular(8),
                    animationDuration: const Duration(milliseconds: 1000),
                  ),
                ),

                const SizedBox(height: 48),

                ProgressLoader(
                  progress: _progress,
                  strategy: PizzaProgressStrategy(),
                  style: const ProgressStyle(
                    width: 100,
                    height: 100,
                    primaryColor: Colors.white,
                    backgroundColor: Colors.transparent,
                  ),
                ),

                const SizedBox(height: 48),

                ProgressLoader(
                  progress: _progress,
                  strategy: const SnowProgressStrategy(
                    snowflakeCount: 30,
                    snowColor: Colors.white,
                  ),
                  style: ProgressStyle(
                    height: 150,
                    primaryColor: Colors.white,
                    backgroundColor: Colors.blue.shade900,
                  ),
                ),

                const SizedBox(height: 60),

                // Refined slider control
                Column(
                  children: [
                    Text(
                      'Adjust Progress',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: _softWhite.withValues(alpha: 0.7),
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 12),
                    SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 3,
                        activeTrackColor: _primaryWhite,
                        inactiveTrackColor: _mediumGray,
                        thumbColor: _primaryWhite,
                        overlayColor: _primaryWhite.withValues(alpha: 0.1),
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 7,
                          elevation: 2,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 18,
                        ),
                      ),
                      child: Slider(
                        value: _progress,
                        onChanged: (value) {
                          setState(() {
                            _progress = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
