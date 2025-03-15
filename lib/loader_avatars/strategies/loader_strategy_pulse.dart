import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutterfx_widgets/loader_avatars/loader_avatars.dart';

class PulseAnimationStrategy extends AvatarAnimationStrategy {
  PulseAnimationStrategy({
    this.animationDuration = const Duration(milliseconds: 800),
    this.baseScale = 1.0,
    this.scaleAmount = 0.3,
    this.waveWidth = 1.0,
    this.phaseShiftFactor = 0.35,
  });

  final Duration animationDuration;
  final double baseScale;
  final double scaleAmount;
  final double waveWidth;
  final double phaseShiftFactor;

  @override
  Duration getAnimationDuration(int index) => animationDuration;

  @override
  Duration getAnimationDelay(int index, int totalAvatars) => Duration.zero;

  @override
  bool get shouldReverseAnimation => true;

  @override
  Widget buildAnimatedAvatar({
    required Widget child,
    required Animation<double> animation,
    required int index,
  }) {
    final scale = _calculatePulseScale(animation.value, index);
    return Transform.scale(
      scale: scale,
      child: child,
    );
  }

  double _calculatePulseScale(double animationValue, int index) {
    final phaseShift = index * phaseShiftFactor;
    var shiftedValue = animationValue - phaseShift;
    while (shiftedValue < 0) {
      shiftedValue += pi * 2;
    }

    var normalizedSine = (sin(shiftedValue) + 1) / 2;
    normalizedSine = pow(normalizedSine, 1 / waveWidth) as double;

    return baseScale + normalizedSine * scaleAmount;
  }
}
