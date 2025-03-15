import 'package:flutter/material.dart';

import 'package:flutterfx_widgets/particles_github_spark/particles_github_spark.dart';
import 'package:flutterfx_widgets/particles_spark_loader/particles_spark_loader.dart';

class ParticlesSparkLoaderDemo extends StatefulWidget {
  const ParticlesSparkLoaderDemo({super.key});

  @override
  State<ParticlesSparkLoaderDemo> createState() => _ParticlesDemoState();
}

class _ParticlesDemoState extends State<ParticlesSparkLoaderDemo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: const Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: StepRotatingShape(
                    size: 25,
                    rotationDuration: Duration(
                      milliseconds: 600,
                    ), // Duration of each 45° rotation
                    pauseDuration: Duration(
                      milliseconds: 300,
                    ), // Pause duration between rotations
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Compiling creative thoughts..',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Positioned.fill(
              child: RisingParticles(
                quantity: 20,
                minSize: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
