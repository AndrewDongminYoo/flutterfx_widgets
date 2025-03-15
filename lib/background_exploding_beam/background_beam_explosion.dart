import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class BackgroundBeamsWithCollision extends StatefulWidget {
  const BackgroundBeamsWithCollision({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  State<BackgroundBeamsWithCollision> createState() => _BackgroundBeamsWithCollisionState();
}

class _BackgroundBeamsWithCollisionState extends State<BackgroundBeamsWithCollision> {
  late List<BeamConfig> beams;
  late double containerWidth;
  late double containerHeight;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    containerWidth = MediaQuery.of(context).size.width;
    containerHeight = MediaQuery.of(context).size.height * 0.85;
    _initializeBeams();
  }

  void _initializeBeams() {
    final random = Random();
    beams = List.generate(
      7,
      (index) => BeamConfig(
        initialX: random.nextDouble() * containerWidth,
        duration: random.nextDouble() * 3 + 1,
        repeatDelay: random.nextDouble() * 3,
        delay: random.nextDouble() * 4,
        height: [24.0, 48.0, 80.0][random.nextInt(3)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: containerHeight,
      width: containerWidth,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ...beams.map(
            (beam) => CollisionMechanism(
              key: ValueKey('${beam.initialX}-beam'),
              beamOptions: beam,
              containerHeight: containerHeight,
            ),
          ),
          if (widget.child != null) Center(child: widget.child),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? const Color(0xFFF5F5F5)
                    : const Color(0xFF262626),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 24,
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

class BeamConfig {
  BeamConfig({
    required this.initialX,
    required this.duration,
    required this.repeatDelay,
    this.delay = 0,
    this.height = 56,
  });

  final double initialX;
  final double duration;
  final double repeatDelay;
  final double delay;
  final double height;
}

class SimpleExplosion extends StatefulWidget {
  const SimpleExplosion({
    super.key,
    required this.position,
  });

  final Offset position;

  @override
  State<SimpleExplosion> createState() => _SimpleExplosionState();
}

class _SimpleExplosionState extends State<SimpleExplosion> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<ExplosionParticle> _particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Create more particles with larger spread
    final random = Random();
    for (var i = 0; i < 20; i++) {
      // Increased number of particles
      final angle = (i * pi * 2) / 20;
      final speed = random.nextDouble() * 40 + 60; // Increased speed
      final radius = random.nextDouble() * 4 + 3; // Increased size

      _particles.add(
        ExplosionParticle(
          angle: angle,
          speed: speed,
          radius: radius,
        ),
      );
    }

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx - 100, // Center the explosion
      top: widget.position.dy - 100, // Center the explosion
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: const Size(200, 200), // Increased size
            painter: ExplosionPainter(
              position: const Offset(100, 100), // Center point
              progress: _controller.value,
              particles: _particles,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ExplosionParticle {
  ExplosionParticle({
    required this.angle,
    required this.speed,
    required this.radius,
  });

  final double angle;
  final double speed;
  final double radius;
}

class ExplosionPainter extends CustomPainter {
  ExplosionPainter({
    required this.position,
    required this.progress,
    required this.particles,
  });

  final Offset position;
  final double progress;
  final List<ExplosionParticle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      // Calculate particle position based on angle and progress
      final distance = particle.speed * progress;
      final dx = cos(particle.angle) * distance;
      final dy = sin(particle.angle) * distance;

      // Create a gradient for the particle
      final gradient = RadialGradient(
        colors: [
          Colors.purple.withValues(alpha: 1 - progress),
          Colors.purple.withValues(alpha: 0),
        ],
      );

      final paint = Paint()
        ..shader = gradient.createShader(
          Rect.fromCircle(
            center: position.translate(dx, dy),
            radius: particle.radius * (1 - progress * 0.5),
          ),
        )
        ..style = PaintingStyle.fill;

      // Draw the particle
      canvas.drawCircle(
        position.translate(dx, dy),
        particle.radius * (1 - progress * 0.3), // Slower shrinking
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ExplosionPainter oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

class CollisionMechanism extends StatefulWidget {
  const CollisionMechanism({
    super.key,
    required this.beamOptions,
    required this.containerHeight,
  });

  final BeamConfig beamOptions;
  final double containerHeight;

  @override
  State<CollisionMechanism> createState() => _CollisionMechanismState();
}

class _CollisionMechanismState extends State<CollisionMechanism> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isColliding = false;
  late Animation<double> _beamAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  void _setupAnimation() {
    _controller = AnimationController(
      duration: Duration(milliseconds: (widget.beamOptions.duration * 1000).toInt()),
      vsync: this,
    );

    // Change animation to go beyond container height
    _beamAnimation = Tween<double>(
      begin: 0,
      end: widget.containerHeight + widget.beamOptions.height * 2, // Go past bottom
    ).animate(_controller);

    // Listen for when beam reaches bottom
    _controller.addListener(() {
      final beamTipPosition = _beamAnimation.value - widget.beamOptions.height;

      // Check if beam tip has hit bottom but hasn't triggered collision yet
      if (beamTipPosition >= widget.containerHeight && !_isColliding) {
        setState(() {
          _isColliding = true;
        });

        // Reset collision flag after explosion duration, but don't reset animation
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) {
            setState(() {
              _isColliding = false;
            });
          }
        });
      }

      // Reset animation when beam is completely off screen
      if (_controller.status == AnimationStatus.completed) {
        Future.delayed(
          Duration(
            milliseconds: (widget.beamOptions.repeatDelay * 1000).toInt(),
          ),
          () {
            if (mounted) {
              _controller.reset();
              _controller.forward();
            }
          },
        );
      }
    });

    Future.delayed(
      Duration(milliseconds: (widget.beamOptions.delay * 1000).toInt()),
      () => _controller.forward(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedBuilder(
          animation: _beamAnimation,
          builder: (context, child) {
            return Positioned(
              left: widget.beamOptions.initialX,
              top: _beamAnimation.value - widget.beamOptions.height,
              child: Container(
                width: 1,
                height: widget.beamOptions.height,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.purple,
                      Colors.indigo,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        if (_isColliding)
          SimpleExplosion(
            position: Offset(
              widget.beamOptions.initialX,
              widget.containerHeight,
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
