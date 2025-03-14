import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutterfx_widgets/loader_avatars/loader_avatars.dart';

class RandomAnimationStrategy extends AvatarAnimationStrategy {
  RandomAnimationStrategy({
    this.maxDisplacement = 12.0,
    this.baseDuration = const Duration(milliseconds: 800),
    this.maxAdditionalDuration = const Duration(milliseconds: 800),
    this.maxInitialDelay = const Duration(milliseconds: 1000),
  });

  final Random _random = Random();
  final double maxDisplacement;
  final Duration baseDuration;
  final Duration maxAdditionalDuration;
  final Duration maxInitialDelay;

  @override
  Duration getAnimationDuration(int index) {
    return baseDuration +
        Duration(
          milliseconds: _random.nextInt(maxAdditionalDuration.inMilliseconds),
        );
  }

  @override
  Duration getAnimationDelay(int index, int totalAvatars) {
    return Duration(
      milliseconds: _random.nextInt(maxInitialDelay.inMilliseconds),
    );
  }

  @override
  bool get shouldReverseAnimation => true;

  @override
  Widget buildAnimatedAvatar({
    required Widget child,
    required Animation<double> animation,
    required int index,
  }) {
    final angle = animation.value;
    final verticalDisplacement = sin(angle) * maxDisplacement;
    final horizontalDisplacement = cos(angle * 1.5) * (maxDisplacement / 3);

    return Transform.translate(
      offset: Offset(horizontalDisplacement, verticalDisplacement),
      child: child,
    );
  }
}
