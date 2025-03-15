import 'package:flutter/material.dart';

import 'package:flutterfx_widgets/smoke/circle_data.dart';

class AnimationSequence {
  AnimationSequence({
    required this.sequences,
    this.stepDuration = const Duration(seconds: 1),
    this.onSequenceChange,
  });

  final List<List<CircleData>> sequences;
  final Duration stepDuration;
  final ValueChanged<int>? onSequenceChange;

  int get length => sequences.length;
}
