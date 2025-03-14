import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:sensors/sensors.dart';

class Gyro3DText extends StatefulWidget {
  const Gyro3DText({
    super.key,
    required this.text,
    this.fontSize = 24,
    this.fontWeight = FontWeight.w900,
    this.fontFamily,
    this.textColor = Colors.black,
    this.shadowColor = const Color(0xFFE39B24),
    this.glareColor = Colors.white,
    this.maxTiltAngle = 35.0,
    this.shadowSensitivity = 0.3,
    this.movementThreshold = 2.0,
    this.smoothingFactor = 0.1,
  });
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final String? fontFamily;
  final Color textColor;
  final Color shadowColor;
  final Color glareColor;
  final double maxTiltAngle;
  final double shadowSensitivity;
  final double movementThreshold;
  final double smoothingFactor;

  @override
  State<Gyro3DText> createState() => _Gyro3DTextState();
}

class _Gyro3DTextState extends State<Gyro3DText> {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  double _xOffset = 0;
  double _yOffset = 0;
  double _lastXOffset = 0;
  double _lastYOffset = 0;

  // Add timer for controlling log frequency
  Timer? _logTimer;
  int _logCounter = 0;

  @override
  void initState() {
    super.initState();
    _startListening();
    // Set up timer for periodic logging
    _logTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      _logCounter++;
    });
  }

  String _getOrientationEmoji(double angle, bool isPitch) {
    if (angle.abs() < widget.movementThreshold) {
      return '⬆️';
    }
    if (isPitch) {
      return angle > 0 ? '⬇️' : '⬆️';
    } else {
      return angle > 0 ? '⬅️' : '➡️';
    }
  }

  String _getTiltIntensity(double angle) {
    final absAngle = angle.abs();
    if (absAngle < widget.movementThreshold) {
      return 'Stable';
    }
    if (absAngle < 10) {
      return 'Slight';
    }
    if (absAngle < 20) {
      return 'Moderate';
    }
    return 'Strong';
  }

  String _generateAsciiArt(double pitch, double roll) {
    final pitchChar = pitch.abs() < widget.movementThreshold ? '━' : (pitch > 0 ? '╱' : '╲');
    final rollChar = roll.abs() < widget.movementThreshold ? '│' : (roll > 0 ? '╱' : '╲');

    return '''
╭───────────────╮
│   ${_getOrientationEmoji(pitch, true)}   ${_getOrientationEmoji(roll, false)}   │
│  $pitchChar$rollChar$pitchChar$rollChar$pitchChar  │
╰───────────────╯''';
  }

  void _logDeviceOrientation(double pitch, double roll) {
    if (_logCounter.isEven) {
      // Log every second
      final timestamp = DateTime.now().toIso8601String();
      final pitchIntensity = _getTiltIntensity(pitch);
      final rollIntensity = _getTiltIntensity(roll);

      print('\n\x1B[36m═══════════ Device Orientation Log ═══════════\x1B[0m');
      print(_generateAsciiArt(pitch, roll));
      print('\x1B[33m┌ Timestamp: $timestamp');
      print('├ Pitch: ${pitch.toStringAsFixed(1)}° ($pitchIntensity tilt)');
      print('├ Roll: ${roll.toStringAsFixed(1)}° ($rollIntensity tilt)');
      print(
        '└ Movement: ${pitch.abs() > widget.movementThreshold || roll.abs() > widget.movementThreshold ? "Active" : "Stable"}\x1B[0m',
      );
    }
  }

  void _startListening() {
    _accelerometerSubscription = accelerometerEvents.listen(
      (AccelerometerEvent event) {
        if (!mounted) {
          return;
        }

        final x = event.x;
        final y = event.y;
        final z = event.z;

        var pitch = (180 / math.pi) * math.atan2(y, math.sqrt(x * x + z * z));
        var roll = (180 / math.pi) * math.atan2(-x, z);

        // Log before applying threshold
        _logDeviceOrientation(pitch, roll);

        pitch = _applyThreshold(pitch);
        roll = _applyThreshold(roll);

        pitch = pitch.clamp(-widget.maxTiltAngle, widget.maxTiltAngle);
        roll = roll.clamp(-widget.maxTiltAngle, widget.maxTiltAngle);

        final newXOffset = -roll * widget.shadowSensitivity;
        final newYOffset = -pitch * widget.shadowSensitivity;

        final smoothedX = _smoothValue(newXOffset, _lastXOffset);
        final smoothedY = _smoothValue(newYOffset, _lastYOffset);

        if (mounted) {
          setState(() {
            _xOffset = smoothedX;
            _yOffset = smoothedY;
            _lastXOffset = smoothedX;
            _lastYOffset = smoothedY;
          });
        }
      },
      onError: (Object? e) {
        print('\x1B[31m🚨 Error from accelerometer: $e\x1B[0m');
      },
      cancelOnError: false,
    );
  }

  double _applyThreshold(double value) {
    if (value.abs() < widget.movementThreshold) {
      return 0;
    }
    return value;
  }

  double _smoothValue(double currentValue, double lastValue) {
    return lastValue + (currentValue - lastValue) * widget.smoothingFactor;
  }

  @override
  void dispose() {
    // ignore: discarded_futures
    _accelerometerSubscription?.cancel();
    _logTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        for (var i = 1; i <= 5; i++)
          Positioned(
            left: _xOffset * i,
            top: _yOffset * i,
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: widget.fontSize,
                fontWeight: widget.fontWeight,
                fontFamily: widget.fontFamily,
                color: widget.shadowColor,
              ),
            ),
          ),
        Text(
          widget.text,
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: widget.fontWeight,
            fontFamily: widget.fontFamily,
            color: widget.textColor,
            shadows: [
              Shadow(
                color: widget.shadowColor.withValues(alpha: 0.3),
                offset: const Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
