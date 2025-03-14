import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:fx_2_folder/noise/noise.dart';

class SimplexNoiseStrategy implements NoiseStrategy {
  SimplexNoiseStrategy() {
    // Initialize permutation table (same as Perlin)
    final permutation = <int>[
      151,
      160,
      137,
      91,
      90,
      15, /*...*/
    ]; // Same as Perlin
    for (var i = 0; i < 256; i++) {
      p[i] = permutation[i];
      p[256 + i] = permutation[i];
    }
  }
  final List<int> p = List.generate(512, (i) => 0);
  static double f2 = 0.5 * (math.sqrt(3.0) - 1.0);
  static double g2 = (3.0 - math.sqrt(3.0)) / 6.0;

  @override
  String get name => 'Simplex Noise';

  @override
  double noise2D(double xin, double yin) {
    double n0;
    double n1;
    double n2;

    // Skew the input space to determine which simplex cell we're in
    final s = (xin + yin) * f2;
    final i = (xin + s).floor();
    final j = (yin + s).floor();

    final t = (i + j) * g2;
    final it = i - t;
    final jt = j - t;
    final x0 = xin - it;
    final y0 = yin - jt;

    // Determine which simplex we are in
    // ignore: avoid_multiple_declarations_per_line
    int i1, j1;
    if (x0 > y0) {
      i1 = 1;
      j1 = 0;
    } else {
      i1 = 0;
      j1 = 1;
    }

    final x1 = x0 - i1 + g2;
    final y1 = y0 - j1 + g2;
    final x2 = x0 - 1.0 + 2.0 * g2;
    final y2 = y0 - 1.0 + 2.0 * g2;

    // Calculate contribution from three corners
    var t0 = 0.5 - x0 * x0 - y0 * y0;
    if (t0 < 0) {
      n0 = 0.0;
    } else {
      t0 *= t0;
      n0 = t0 * t0 * _grad(p[(i + p[j & 255]) & 255], x0, y0);
    }

    var t1 = 0.5 - x1 * x1 - y1 * y1;
    if (t1 < 0) {
      n1 = 0.0;
    } else {
      t1 *= t1;
      n1 = t1 * t1 * _grad(p[(i + i1 + p[(j + j1) & 255]) & 255], x1, y1);
    }

    var t2 = 0.5 - x2 * x2 - y2 * y2;
    if (t2 < 0) {
      n2 = 0.0;
    } else {
      t2 *= t2;
      n2 = t2 * t2 * _grad(p[(i + 1 + p[(j + 1) & 255]) & 255], x2, y2);
    }

    // Add contributions from each corner to get the final noise value.
    // The result is scaled to return values in the interval [-1,1].
    return 70.0 * (n0 + n1 + n2);
  }

  double _grad(int hash, double x, double y) {
    // Same as Perlin noise grad
    final h = hash & 15;
    final u = h < 8 ? x : y;
    final v = h < 4
        ? y
        : h == 12 || h == 14
            ? x
            : 0;
    return ((h & 1) == 0 ? u : -u) + ((h & 2) == 0 ? v : -v);
  }

  @override
  Color getColor(double value) {
    // ignore: parameter_assignments
    value = (value + 1) / 2; // Normalize to 0-1
    return Color.fromRGBO(
      (value * 255).round(),
      (value * 255).round(),
      (value * 255).round(),
      1,
    );
  }
}

// 2. Worley (Cellular) Noise Strategy
class WorleyNoiseStrategy implements NoiseStrategy {
  WorleyNoiseStrategy({this.numPoints = 20}) {
    // Generate random feature points
    for (var i = 0; i < numPoints; i++) {
      _points.add(Offset(_random.nextDouble(), _random.nextDouble()));
    }
  }
  final math.Random _random = math.Random(42);
  final List<Offset> _points = [];
  final int numPoints;

  @override
  String get name => 'Worley Noise';

  @override
  double noise2D(double x, double y) {
    var minDist = double.infinity;
    var secondMinDist = double.infinity;

    // Find distances to the closest points
    for (final point in _points) {
      final dx = x - point.dx;
      final dy = y - point.dy;
      final dist = math.sqrt(dx * dx + dy * dy);

      if (dist < minDist) {
        secondMinDist = minDist;
        minDist = dist;
      } else if (dist < secondMinDist) {
        secondMinDist = dist;
      }
    }

    // Return f2-F1 difference
    return secondMinDist - minDist;
  }

  @override
  Color getColor(double value) {
    // ignore: parameter_assignments
    value = value.clamp(0, 1);
    return Color.fromRGBO(
      (value * 255).round(),
      ((1 - value) * 255).round(),
      (value * 128).round(),
      1,
    );
  }
}

// 3. Fractional Brownian Motion Strategy
class FBMNoiseStrategy implements NoiseStrategy {
  FBMNoiseStrategy({
    NoiseStrategy? baseNoise,
    this.octaves = 6,
    this.persistence = 0.5,
    this.lacunarity = 2.0,
  }) : baseNoise = baseNoise ?? SimplexNoiseStrategy();
  final NoiseStrategy baseNoise;
  final int octaves;
  final double persistence;
  final double lacunarity;

  @override
  String get name => 'Fractional Brownian Motion';

  @override
  double noise2D(double x, double y) {
    var total = 0.0;
    var frequency = 1.0;
    var amplitude = 1.0;
    var maxValue = 0.0;

    for (var i = 0; i < octaves; i++) {
      total += baseNoise.noise2D(x * frequency, y * frequency) * amplitude;
      maxValue += amplitude;
      amplitude *= persistence;
      frequency *= lacunarity;
    }

    return total / maxValue;
  }

  @override
  Color getColor(double value) {
    // ignore: parameter_assignments
    value = (value + 1) / 2;
    return HSVColor.fromAHSV(1, value * 360, 0.7, value).toColor();
  }
}

// 4. Voronoi Noise Strategy
class VoronoiNoiseStrategy implements NoiseStrategy {
  VoronoiNoiseStrategy({this.numPoints = 20}) {
    for (var i = 0; i < numPoints; i++) {
      _points.add(Offset(_random.nextDouble(), _random.nextDouble()));
    }
  }
  final math.Random _random = math.Random(42);
  final List<Offset> _points = [];
  final int numPoints;

  @override
  String get name => 'Voronoi Noise';

  @override
  double noise2D(double x, double y) {
    var minDist = double.infinity;
    var closestIndex = 0;

    for (var i = 0; i < _points.length; i++) {
      final dx = x - _points[i].dx;
      final dy = y - _points[i].dy;
      final dist = dx * dx + dy * dy; // Square distance is enough

      if (dist < minDist) {
        minDist = dist;
        closestIndex = i;
      }
    }

    // Return normalized index of closest point
    return closestIndex / _points.length;
  }

  @override
  Color getColor(double value) {
    // Create distinct colors for different cells
    return HSVColor.fromAHSV(1, value * 360, 0.8, 0.9).toColor();
  }
}
