import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:fx_2_folder/smoke/circle_data.dart';

List<List<CircleData>> generateRandomCircleSets(int N, int setCount) {
  assert(N > 0 && setCount > 0, 'N and setCount must be positive integers');

  final random = math.Random();
  final sequences = <List<CircleData>>[];
  final usedQuadrants = <int>{};

  for (var set = 0; set < setCount; set++) {
    final circleSet = <CircleData>[];
    int quadrant;

    // Choose a random quadrant that hasn't been used
    do {
      quadrant = random.nextInt(4);
    } while (usedQuadrants.contains(quadrant) && usedQuadrants.length < 4);
    usedQuadrants.add(quadrant);

    // Generate the main circle for this set
    final mainPosition = _getRandomPositionInQuadrant(quadrant, random);
    circleSet.add(_generateCircleData('0', mainPosition, random));

    // Generate satellite circles
    for (var i = 1; i < N; i++) {
      final satellitePosition = _getNearbySatellitePosition(mainPosition, random);
      circleSet.add(_generateCircleData(i.toString(), satellitePosition, random));
    }

    sequences.add(circleSet);
  }

  return sequences;
}

Offset _getRandomPositionInQuadrant(int quadrant, math.Random random) {
  double x;
  double y;
  switch (quadrant) {
    case 0: // Top-left
      x = random.nextDouble() * 0.5;
      y = random.nextDouble() * 0.5;
    case 1: // Top-right
      x = 0.5 + random.nextDouble() * 0.5;
      y = random.nextDouble() * 0.5;
    case 2: // Bottom-left
      x = random.nextDouble() * 0.5;
      y = 0.5 + random.nextDouble() * 0.5;
    case 3: // Bottom-right
      x = 0.5 + random.nextDouble() * 0.5;
      y = 0.5 + random.nextDouble() * 0.5;
    default:
      throw ArgumentError('Invalid quadrant');
  }
  return Offset(x, y);
}

Offset _getNearbySatellitePosition(Offset mainPosition, math.Random random) {
  final angle = random.nextDouble() * 2 * math.pi;
  final distance = random.nextDouble() * 0.5; // Adjust this value to control spread
  final x = mainPosition.dx + distance * math.cos(angle);
  final y = mainPosition.dy + distance * math.sin(angle);
  return Offset(x.clamp(0.0, 1.0), y.clamp(0.0, 1.0));
}

CircleData _generateCircleData(String id, Offset position, math.Random random) {
  return CircleData(
    id: id,
    normalizedPosition: position,
    radius: random.nextDouble() * 100 + 30, // Random radius between 10 and 40
    color: Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    ),
  );
}
