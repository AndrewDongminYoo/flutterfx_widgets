import 'package:flutter/material.dart';

import 'package:fx_2_folder/thanos_snap/thanos_snap.dart';

class ThanosSnapDemo extends StatelessWidget {
  const ThanosSnapDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final snapKey = GlobalKey<ThanosSnapEffectState>();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ThanosSnapEffect(
              key: snapKey,
              onComplete: () {
                debugPrint('Snap effect completed!');
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text('Snap Me!'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await snapKey.currentState?.snap();
              },
              child: const Text('Trigger Snap Effect'),
            ),
          ],
        ),
      ),
    );
  }
}
