import 'dart:math' as math;

import 'package:flutter/material.dart';

class SpringAnimationsPage extends StatelessWidget {
  const SpringAnimationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spring Animations'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        childAspectRatio: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          const SpringButton(
            text: 'Elastic Gentle',
            curve: Curves.easeOutBack,
            duration: Duration(milliseconds: 800),
          ),
          SpringButton(
            text: 'Bouncy Wobble',
            curve: _BouncyWobbleCurve(),
            duration: const Duration(milliseconds: 1200),
          ),
          SpringButton(
            text: 'Quick Oscillation',
            curve: _QuickOscillationCurve(),
            duration: const Duration(milliseconds: 600),
          ),
          SpringButton(
            text: 'Slow Rebound',
            curve: _SlowReboundCurve(),
            duration: const Duration(milliseconds: 1500),
          ),
          SpringButton(
            text: 'Snappy Elastic',
            curve: _SnappyElasticCurve(),
            duration: const Duration(milliseconds: 700),
          ),
          SpringButton(
            text: 'Soft Bounce',
            curve: _SoftBounceCurve(),
            duration: const Duration(milliseconds: 900),
          ),
          SpringButton(
            text: 'Vibrating Spring',
            curve: _VibratingSpringCurve(),
            duration: const Duration(milliseconds: 1000),
          ),
          SpringButton(
            text: 'Smooth Overshoot',
            curve: _SmoothOvershootCurve(),
            duration: const Duration(milliseconds: 850),
          ),
          SpringButton(
            text: 'Elastic Snap',
            curve: _ElasticSnapCurve(),
            duration: const Duration(milliseconds: 750),
          ),
          SpringButton(
            text: 'Gentle Wobble',
            curve: _GentleWobbleCurve(),
            duration: const Duration(milliseconds: 1100),
          ),
          const SpringButton(
            text: 'Bouncy',
            curve: Curves.bounceOut,
            duration: Duration(milliseconds: 500),
          ),
          const SpringButton(
            text: 'Elastic',
            curve: Curves.elasticOut,
            duration: Duration(milliseconds: 1000),
          ),
          const SpringButton(
            text: 'Quick Snap',
            curve: Curves.easeOutBack,
            duration: Duration(milliseconds: 300),
          ),
          const SpringButton(
            text: 'Slow Spring',
            curve: Curves.elasticInOut,
            duration: Duration(milliseconds: 1500),
          ),
          const SpringButton(
            text: 'Overshoot',
            curve: Curves.easeOutCirc,
            duration: Duration(milliseconds: 600),
          ),
          const SpringButton(
            text: 'Gentle',
            curve: Curves.easeOutSine,
            duration: Duration(milliseconds: 400),
          ),
          const SpringButton(
            text: 'Sharp',
            curve: Curves.easeOutExpo,
            duration: Duration(milliseconds: 350),
          ),
          SpringButton(
            text: 'Wobble',
            curve: _WobbleCurve(),
            duration: const Duration(milliseconds: 800),
          ),
          SpringButton(
            text: 'Bouncy Elastic',
            curve: _BouncyElasticCurve(),
            duration: const Duration(milliseconds: 1200),
          ),
          SpringButton(
            text: 'Damped',
            curve: _DampedSpringCurve(),
            duration: const Duration(milliseconds: 1000),
          ),
        ],
      ),
    );
  }
}

class SpringButton extends StatefulWidget {
  const SpringButton({
    super.key,
    required this.text,
    required this.curve,
    required this.duration,
  });
  final String text;
  final Curve curve;
  final Duration duration;

  @override
  SpringButtonState createState() => SpringButtonState();
}

class SpringButtonState extends State<SpringButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward(from: 0);
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.rotate(
            angle: math.sin(_animation.value * math.pi) * 10 * math.pi / 180,
            child: ElevatedButton(
              onPressed: () {
                _controller.forward(from: 0);
              },
              child: Text(widget.text),
            ),
          );
        },
      ),
    );
  }
}

class _WobbleCurve extends Curve {
  @override
  double transform(double t) {
    return math.sin(t * math.pi * 4) * (1 - t);
  }
}

class _BouncyElasticCurve extends Curve {
  @override
  double transform(double t) {
    return -math.pow(math.e, -8 * t) * math.cos(t * 12) + 1;
  }
}

class _DampedSpringCurve extends Curve {
  @override
  double transform(double t) {
    return 1 - math.pow(math.e, -3 * t) * math.cos(t * 10);
  }
}

class _BouncyWobbleCurve extends Curve {
  @override
  double transform(double t) {
    return -math.pow(math.e, -5 * t) * math.cos(t * 15) + 1;
  }
}

class _QuickOscillationCurve extends Curve {
  @override
  double transform(double t) {
    return math.sin(t * math.pi * 6) * (1 - t) + t;
  }
}

class _SlowReboundCurve extends Curve {
  @override
  double transform(double t) {
    return (1 - math.pow(math.cos(t * math.pi / 2), 3)).toDouble();
  }
}

class _SnappyElasticCurve extends Curve {
  @override
  double transform(double t) {
    return -math.pow(2, -10 * t) * math.sin((t - 0.1) * 5 * math.pi) + 1;
  }
}

class _SoftBounceCurve extends Curve {
  @override
  double transform(double t) {
    return 1 - math.pow(1 - t, 3) * math.cos(t * math.pi * 2);
  }
}

class _VibratingSpringCurve extends Curve {
  @override
  double transform(double t) {
    return math.sin(t * 15) * math.pow(1 - t, 2) + t;
  }
}

class _SmoothOvershootCurve extends Curve {
  @override
  double transform(double t) {
    return t * t * (3 - 2 * t) + math.sin(t * math.pi * 2) * 0.1;
  }
}

class _ElasticSnapCurve extends Curve {
  @override
  double transform(double t) {
    return math.pow(2, -8 * t) * math.sin(t * 8 * math.pi) + 1;
  }
}

class _GentleWobbleCurve extends Curve {
  @override
  double transform(double t) {
    return t + math.sin(t * math.pi * 3) * 0.1 * (1 - t);
  }
}
