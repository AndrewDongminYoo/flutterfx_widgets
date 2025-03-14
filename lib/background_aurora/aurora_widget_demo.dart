import 'package:flutter/material.dart';

import 'package:flutterfx_widgets/background_aurora/aurora_widget.dart';

class AuroraDemo extends StatelessWidget {
  const AuroraDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return AuroraBackground(
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[850]?.withValues(alpha: 0.7)
                : Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Aurora Background',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'A beautiful animated background effect',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
