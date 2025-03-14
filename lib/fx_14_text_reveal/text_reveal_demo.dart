import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:fx_2_folder/fx_14_text_reveal/strategies/fade_blur_strategy.dart';
import 'package:fx_2_folder/fx_14_text_reveal/strategies/flip_up_strategy.dart';
import 'package:fx_2_folder/fx_14_text_reveal/strategies/flying_characters_strategy.dart';
import 'package:fx_2_folder/fx_14_text_reveal/strategies/swirl_float_strategy.dart';
import 'package:fx_2_folder/fx_14_text_reveal/text_reveal_widget.dart';

// Animation Strategy Selection Model
class AnimationPreset {
  const AnimationPreset({
    required this.name,
    required this.strategy,
    required this.description,
  });
  final String name;
  final TextAnimationStrategy strategy;
  final String description;
}

class AnimationDemoScreen extends StatefulWidget {
  const AnimationDemoScreen({super.key});

  @override
  State<AnimationDemoScreen> createState() => _AnimationDemoScreenState();
}

class _AnimationDemoScreenState extends State<AnimationDemoScreen> {
  bool _isAnimating = false;
  final String _demoText = 'Flutter is pure magic! ✨';
  AnimationUnit _selectedUnit = AnimationUnit.character;
  AnimationDirection _direction = AnimationDirection.forward;
  late AnimationPreset _selectedPreset;
  final TextEditingController _textController = TextEditingController();

  // Define animation presets
  final List<AnimationPreset> presets = const [
    AnimationPreset(
      name: 'Classic Fade & Blur',
      strategy: FadeBlurStrategy(),
      description: 'Smooth fade in with gaussian blur effect',
    ),
    AnimationPreset(
      name: 'Gentle Float',
      strategy: FlyingCharactersStrategy(
        maxOffset: 50,
        randomDirection: false,
        angle: -math.pi / 2,
      ),
      description: 'Characters float up gently',
    ),
    AnimationPreset(
      name: 'Gentle Float with Blur',
      strategy: FlyingCharactersStrategy(
        maxOffset: 50,
        randomDirection: false,
        enableBlur: true,
        angle: -math.pi / 2,
      ),
      description: 'Characters float up gently',
    ),
    AnimationPreset(
      name: 'Chaos Scatter',
      strategy: FlyingCharactersStrategy(
        maxOffset: 50,
      ),
      description: 'Characters scatter in random directions',
    ),
    AnimationPreset(
      name: 'Chaos Scatter with Blur',
      strategy: FlyingCharactersStrategy(
        maxOffset: 50,
        enableBlur: true,
      ),
      description: 'Characters scatter in random directions',
    ),
    AnimationPreset(
      name: 'Swirl Float',
      strategy: SwirlFloatStrategy(
        yOffset: -200,
        maxXDeviation: 60,
        maxBlur: 10,
        enableBlur: false,
        curveIntensity: 0.7, // More pronounced S-curve
        synchronizeAnimation: true,
      ),
      description: 'Characters float in a swirl',
    ),
    AnimationPreset(
      name: 'Swirl Float with Blur',
      strategy: SwirlFloatStrategy(
        yOffset: -200,
        maxXDeviation: 60,
        maxBlur: 10,
        curveIntensity: 0.7,
        synchronizeAnimation: true, // More pronounced S-curve
      ),
      description: 'Characters float in a swirl',
    ),
    AnimationPreset(
      name: 'Flip up',
      strategy: FlipUpStrategy(
        perspectiveValue: 0.02, // Adjust for more/less dramatic perspective
      ),
      description: 'Characters flip up using 3d transform',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedPreset = presets[0];
    _textController.text = _demoText;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Card(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Animation Preview Area
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: 100,
                    ),
                    child: EnhancedTextRevealEffect(
                      text: _demoText,
                      trigger: _isAnimating,
                      strategy: _selectedPreset.strategy,
                      unit: _selectedUnit,
                      direction: _direction,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ), // Replace with your actual widget
                  ),

                  const SizedBox(height: 32),

                  // Controls Section
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _isAnimating = !_isAnimating;
                        });
                      },
                      icon: Icon(
                        _isAnimating ? Icons.stop_rounded : Icons.play_arrow_rounded,
                      ),
                      label: Text(_isAnimating ? 'Reset' : 'Play'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Animation Settings
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      // Animation Preset Selector
                      DropdownButton<AnimationPreset>(
                        value: _selectedPreset,
                        items: presets.map((preset) {
                          return DropdownMenuItem(
                            value: preset,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(preset.name),
                                // Text(
                                //   preset.description,
                                //   style: TextStyle(
                                //     fontSize: 12,
                                //     color: Colors.grey[600],
                                //   ),
                                // ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (preset) {
                          if (preset != null) {
                            setState(() {
                              _selectedPreset = preset;
                            });
                          }
                        },
                      ),
                      const SizedBox(width: 16),

                      // Animation Unit Selector
                      SegmentedButton<AnimationUnit>(
                        segments: const [
                          ButtonSegment(
                            value: AnimationUnit.character,
                            label: Text('Character'),
                            icon: Icon(Icons.text_fields),
                          ),
                          ButtonSegment(
                            value: AnimationUnit.word,
                            label: Text('Word'),
                            icon: Icon(Icons.wrap_text),
                          ),
                        ],
                        selected: {_selectedUnit},
                        onSelectionChanged: (Set<AnimationUnit> selection) {
                          setState(() {
                            _selectedUnit = selection.first;
                          });
                        },
                      ),
                      const SizedBox(width: 16),

                      // Direction Selector
                      SegmentedButton<AnimationDirection>(
                        segments: const [
                          ButtonSegment(
                            value: AnimationDirection.forward,
                            label: Text('Forward'),
                            icon: Icon(Icons.arrow_forward),
                          ),
                          ButtonSegment(
                            value: AnimationDirection.reverse,
                            label: Text('Reverse'),
                            icon: Icon(Icons.arrow_back),
                          ),
                        ],
                        selected: {_direction},
                        onSelectionChanged: (Set<AnimationDirection> selection) {
                          setState(() {
                            _direction = selection.first;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
