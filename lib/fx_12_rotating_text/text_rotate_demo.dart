import 'package:flutter/material.dart';

import 'package:fx_2_folder/fx_12_rotating_text/text_rotate.dart';

class TextRotateDemo extends StatefulWidget {
  const TextRotateDemo({super.key});

  @override
  State<TextRotateDemo> createState() => _TextRotateDemoState();
}

class _TextRotateDemoState extends State<TextRotateDemo> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: const IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: RotatingTextWidget(
                          text: 'Your rotating text here',
                          radius: 100,
                          textStyle: TextStyle(fontSize: 18, color: Colors.blue),
                          rotationDuration: Duration(seconds: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
