import 'package:flutter/material.dart';

import 'package:flutterfx_widgets/globe/globe.dart';
import 'package:flutterfx_widgets/globe/icon_helper.dart';

class TechStackCloud extends StatelessWidget {
  TechStackCloud({super.key});

  final List<String> slugs = [
    'typescript',
    'javascript',
    'dart',
    'java',
    'react',
    'flutter',
    'android',
    'html5',
    'css3',
    'node.js',
    'express',
    'next.js',
    'prisma',
    'amazonaws',
    'postgresql',
    'firebase',
    'nginx',
    'vercel',
    'testinglibrary',
    'jest',
    'cypress',
    'docker',
    'git',
    'jira',
    'github',
    'gitlab',
    'visualstudiocode',
    'androidstudio',
    'sonar',
    'figma',
  ];

  @override
  Widget build(BuildContext context) {
    // Get icons using the helper
    final icons = TechStackIcons.getIconsFromSlugs(slugs);

    return Center(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(16),
        ),
        child: GlobeOfLogos(
          icons: icons,
          radius: 120,
          defaultIconColor: Colors.white70,
        ),
      ),
    );
  }
}

// Example page using the TechStackCloud
class TechStackDemo extends StatelessWidget {
  const TechStackDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: TechStackCloud(),
    );
  }
}
