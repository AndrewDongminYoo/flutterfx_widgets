import 'package:flutter/material.dart';

class MinimalistBookCover extends StatelessWidget {
  const MinimalistBookCover({
    super.key,
    required this.title,
    required this.author,
    this.backgroundColor = const Color(0xFFFF6B6B),
    this.textColor = Colors.white,
  });

  final String title;
  final String author;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate font sizes based on container size
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;

        // Adaptive font sizes
        final titleFontSize = maxHeight * 0.12; // 12% of height
        final authorFontSize = maxHeight * 0.05; // 5% of height

        return DecoratedBox(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: EdgeInsets.all(maxWidth * 0.08), // Responsive padding
            child: Column(
              children: [
                // Flexible container for title
                Expanded(
                  flex: 7,
                  child: Center(
                    child: FittedBox(
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: maxWidth * 0.9,
                        ),
                        child: Text(
                          title.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: textColor,
                            fontSize: titleFontSize,
                            height: 1.1,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Spacer with minimum height
                SizedBox(height: maxHeight * 0.02),

                // Author section at bottom
                SizedBox(
                  height: maxHeight * 0.1, // 10% of height for author section
                  child: FittedBox(
                    child: Text(
                      author.toUpperCase(),
                      style: TextStyle(
                        color: textColor.withValues(alpha: 0.9),
                        fontSize: authorFontSize,
                        fontWeight: FontWeight.w500,
                        letterSpacing: titleFontSize * 0.05,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BookCoverPresets {
  static const ({Color background, Color text}) coral = (
    background: Color(0xFFFF6B6B),
    text: Colors.white,
  );

  static const ({Color background, Color text}) orange = (
    background: Color(0xFFFF8C42),
    text: Colors.white,
  );

  static const ({Color background, Color text}) mint = (
    background: Color(0xFF2FBF71),
    text: Colors.white,
  );
}
