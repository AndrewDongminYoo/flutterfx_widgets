import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:fx_2_folder/avatar_circles/avatar_circles.dart';
import 'package:fx_2_folder/background_aurora/aurora_widget_demo.dart';
import 'package:fx_2_folder/background_beam/background_beam_demo.dart';
import 'package:fx_2_folder/background_exploding_beam/background_beam_explosion_demo.dart';
import 'package:fx_2_folder/background_flicker_grid/background_flicker_grid.dart';
import 'package:fx_2_folder/background_flickering_card/background_flickering_card.dart';
import 'package:fx_2_folder/background_grid_blinker/background_grid_blinker.dart';
import 'package:fx_2_folder/background_grid_motion/background_grid_motion.dart';
import 'package:fx_2_folder/background_orbital_star/background_orbital_star.dart';
import 'package:fx_2_folder/background_ripples/background_ripples.dart';
import 'package:fx_2_folder/book_open/book_open_demo.dart';
import 'package:fx_2_folder/books/books.dart';
import 'package:fx_2_folder/bottom_sheet/bottom_sheet_demo.dart';
import 'package:fx_2_folder/butterfly/butterfly_demo.dart';
import 'package:fx_2_folder/butterfly_interactive/butterfly_interactive_demo.dart';
import 'package:fx_2_folder/button_shimmer/button_shimmer_demo.dart';
import 'package:fx_2_folder/celebrate/celebrate_demo.dart';
import 'package:fx_2_folder/circles_selector/circles_home_widget.dart';
import 'package:fx_2_folder/confetti/confetti_demo.dart';
import 'package:fx_2_folder/debug_overlay_3d/debug_overlay_3d.dart';
import 'package:fx_2_folder/decoration_bulbs/decoration_bulbs_demo.dart';
import 'package:fx_2_folder/decoration_thread/decoration_thread_demo_1.dart';
import 'package:fx_2_folder/dots/dots_demo.dart';
import 'package:fx_2_folder/expandable_widget/expandable_widget.dart';
import 'package:fx_2_folder/folder_shape/folder_home.dart';
import 'package:fx_2_folder/fractal_glass/fractal_glass.dart';
import 'package:fx_2_folder/frosty_card/frosty_card.dart';
import 'package:fx_2_folder/fx_10_hyper_text/hyper_text_demo.dart';
import 'package:fx_2_folder/fx_11_typing_animation/typing_anim_demo.dart';
import 'package:fx_2_folder/fx_12_rotating_text/text_rotate_demo.dart';
import 'package:fx_2_folder/fx_13_rotating_text_with_blur/text_rotate_blur_demo.dart';
import 'package:fx_2_folder/fx_14_text_chaotic_spring/demo.dart';
import 'package:fx_2_folder/fx_14_text_reveal/text_reveal_demo.dart';
import 'package:fx_2_folder/fx_7_border_beam/border_beam_demo.dart';
import 'package:fx_2_folder/fx_8_meteor_border/meteors_demo.dart';
import 'package:fx_2_folder/fx_9_neon_card/neon_card_demo.dart';
import 'package:fx_2_folder/gemini_splash/gemini_splash_demo.dart';
import 'package:fx_2_folder/globe/cloud_demo.dart';
import 'package:fx_2_folder/grid_animated/grid_animated.dart';
import 'package:fx_2_folder/infinite_scrolling/infinite_scrolling.dart';
import 'package:fx_2_folder/infinite_scrolling/infinite_scrolling_3d.dart';
import 'package:fx_2_folder/light_bulb_night_mode/light_bulb_demo.dart';
import 'package:fx_2_folder/light_effect/light_effect_demo.dart';
import 'package:fx_2_folder/loader_avatars/loader_avatars_demo.dart';
import 'package:fx_2_folder/loader_avatars/loader_avatars_demo_2.dart';
import 'package:fx_2_folder/loader_sphere/loader_sphere_demo.dart';
import 'package:fx_2_folder/loader_square/loader_square_demo.dart';
import 'package:fx_2_folder/noise/noise_demo.dart';
import 'package:fx_2_folder/notification_list/notification_list.dart';
import 'package:fx_2_folder/orbit/orbit_demo.dart';
import 'package:fx_2_folder/orbit_blur/orbit_blur_demo.dart';
import 'package:fx_2_folder/page_flip/page_flip.dart';
import 'package:fx_2_folder/particles/particles_demo.dart';
import 'package:fx_2_folder/particles_github_spark/particles_github_spark_demo.dart';
import 'package:fx_2_folder/particles_spark_loader/particles_spark_loader_demo.dart';
import 'package:fx_2_folder/primitives/primitives_demo.dart';
import 'package:fx_2_folder/scratch_to_reveal/scratch_to_reveal.dart';
import 'package:fx_2_folder/scroll_progress/scroll_progress_demo.dart';
import 'package:fx_2_folder/shader_learning/shader_1.dart';
import 'package:fx_2_folder/slider/slider_demo.dart';
import 'package:fx_2_folder/smoke/smoke.dart';
import 'package:fx_2_folder/splash_door_open/splash_door_open.dart';
import 'package:fx_2_folder/splash_reveal/splash_demo.dart';
import 'package:fx_2_folder/stacked_cards/stacked_card.dart';
import 'package:fx_2_folder/stacked_expand_cards/stacked_expand_card.dart';
import 'package:fx_2_folder/stacked_scroll/stacked_scroll_demo.dart';
import 'package:fx_2_folder/text_3d_pop/text_3d_pop_demo.dart';
import 'package:fx_2_folder/text_morph/text_morph.dart';
import 'package:fx_2_folder/text_on_path/text_on_path_demo.dart';
import 'package:fx_2_folder/text_shine/text_shine.dart';
import 'package:fx_2_folder/ticker/ticker.dart';
import 'package:fx_2_folder/toolbar_search/toolbar_search.dart';
import 'package:fx_2_folder/tree/tree.dart';
import 'package:fx_2_folder/vinyl/vinyl.dart';
import 'package:fx_2_folder/visibility/blur_fade.dart';

void main() => runApp(const AnimationShowcaseApp());

class AnimationShowcaseApp extends StatelessWidget {
  const AnimationShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'fx-widget Showcase',
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF1E1E1E),
        scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
        cardColor: const Color(0xFF2C2C2C),
        textTheme: GoogleFonts.robotoMonoTextTheme(
          Theme.of(context).textTheme,
        ).apply(bodyColor: Colors.white),
      ),
      home: HomeScreen(),
    );
  }
}

class AnimationExample {
  AnimationExample({
    required this.title,
    required this.builder,
    this.appBarColor,
    this.isFullScreen = false,
  });

  final String title;
  final Widget Function(BuildContext) builder;
  final Color? appBarColor;
  final bool isFullScreen;
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<AnimationExample> examples = [
    AnimationExample(
      title: 'Folder',
      builder: (context) => const FolderHomeWidget(
        curve: Curves.easeInOutBack,
        title: 'EaseInOutBack',
      ),
    ),
    AnimationExample(
      title: 'Smoke',
      builder: (context) => const SmokeHomeWidget(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: 'Books',
      builder: (context) => const BookShelfPage(title: 'Flutter Demo Home Page'),
    ),
    AnimationExample(
      title: 'CircleSelector',
      builder: (context) => const CirclesHomeWidget(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: '3D Vinyl',
      builder: (context) => const VinylHomeWidget(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'BlurFade',
      builder: (context) => const BlurFadeExample(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'FrostyCard[WIP]',
      builder: (context) => const FrostyCardDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Border beam',
      builder: (context) => const BorderBeamHomeWidget(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Meteors',
      builder: (context) => const MeteorDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Neon Card',
      builder: (context) => const NeonGradientCardDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Hyper Text',
      builder: (context) => const HyperTextDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Typing animation',
      builder: (context) => const TypingAnimationDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'RotatingText',
      builder: (context) => const TextRotateDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'TextReveal',
      builder: (context) => const AnimationDemoScreen(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Globe of Logos',
      builder: (context) => const TechStackDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Celebrate',
      builder: (context) => const CelebrateHomeWidget(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'LightEffect',
      builder: (context) => const LightEffectWidgetDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Orbit',
      builder: (context) => const OrbitDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Particles',
      builder: (context) => const ParticlesDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Particles like GithubSpark',
      builder: (context) => const ParticlesGithubSparkDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'GithubSpark Loader',
      builder: (context) => const ParticlesSparkLoaderDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'DotPattern',
      builder: (context) => const DotPatternWidget(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Text On Path',
      builder: (context) => const TextOnPathDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Background Beams',
      builder: (context) => const BackgroundBeamDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Exploding Beams',
      builder: (context) => const ExplodingBeamDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Motion Primitives[wip]',
      builder: (context) => const MotionPrimitiveDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Work Life Slider',
      builder: (context) => const SliderDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Stacked Scroll [WIP]',
      builder: (context) => const StackedScrollDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Night Mode Bulb',
      builder: (context) => const NightModeDemo(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: 'Stacked Cards',
      builder: (context) => const StackedCardDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Stacked Expand Cards',
      builder: (context) => const StackedExpandedCardDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Confetti [WIP]',
      builder: (context) => const ConfettiDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Shimmer Button',
      builder: (context) => const ButtonShimmerDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'BottomSheet',
      builder: (context) => const BottomSheetDemo(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: 'ButterFly',
      builder: (context) => const ButterflyDemo(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: 'BookOpen',
      builder: (context) => const BookOpenDemo(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: 'RotatingBlurText [WIP]',
      builder: (context) => const TextRotateBlurDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Scroll Progress',
      builder: (context) => const ScrollProgressDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Sphere Loader',
      builder: (context) => const LoaderSphereDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Text 3D Pop',
      builder: (context) => const Text3dPopDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Aurora Background [WIP]',
      builder: (context) => const AuroraDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Orbit with Blur',
      builder: (context) => const OrbitExtendedDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Gemini Splash',
      builder: (context) => const SparkleDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Text Chaotic Spring',
      builder: (context) => const TextChaoticSpringDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Interactive Butterfly',
      builder: (context) => const ButterflyInteractiveDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Avatar Loader',
      builder: (context) => const LoaderAvatarsDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Avatar Loader - 2',
      builder: (context) => const LoaderAvatarsDemo2(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Noise [WIP]',
      builder: (context) => const PracticalNoiseShowcase(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Splash Circular Reveal',
      builder: (context) => const LoadingApp1(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: 'Orbital Star',
      builder: (context) => const BgOrbitalStarDemo(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: 'Loader Square',
      builder: (context) => const LoaderSquareDemo(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: 'DecorationBulbsDemo',
      builder: (context) => const DecorationBulbsDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'DecorationThreadDemo',
      builder: (context) => const GlowingThreadDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Grid Animation',
      builder: (context) => const GridAnimatedDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Grid in Motion',
      builder: (context) => const RetroGridDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Flickering Grid Demo',
      builder: (context) => const FlickeringGridDemo(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: 'Flickering Cards Demo',
      builder: (context) => const ColorfulCardsDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: '[WIP] FractalGLass Effect',
      builder: (context) => const FractalGlassDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Moving Ticker Effect',
      builder: (context) => const LayeredTickers(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: 'Simple Shader',
      builder: (context) => const SimpleShaderExample(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: 'Infinite Scrolling',
      builder: (context) => MarqueeDemo(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: 'Infinite Scrolling 3D',
      builder: (context) => Marquee3D(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: 'Page Flip',
      builder: (context) => const PageFlipDemo(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: 'Avatar Circles',
      builder: (context) => AvatarCirclesShowcase(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: 'Notification List',
      builder: (context) => NotificationDemo(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: 'Splash Door Open Reveal',
      builder: (context) => const SplashDoorOpenRevealDemo(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: 'Background Ripples',
      builder: (context) => const BackgroundRippleDemo(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: 'Scratch to Reveal',
      builder: (context) => const ScratchToRevealDemo(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: 'Shining Text',
      builder: (context) => const TextShiningDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Debug Overlay',
      builder: (context) => const OverlayDebugDemo(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: 'Grid Blinker',
      builder: (context) => const GridBlinkerDemo(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: 'Tree',
      builder: (context) => const TreeDemo(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: 'Expandable Widget',
      builder: (context) => const ExpandableWidgetDemo(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: 'Text Morph',
      builder: (context) => const TextMorphDemo(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: '[WIP] Toolbar Search ',
      builder: (context) => const ToolbarSearchDemo(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Automatically navigate to the first example on launch (e.g., "Folder").
    Future.microtask(() async {
      if (examples.isNotEmpty) {
        await Navigator.push<void>(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DetailScreen(
                example: examples[examples.length - 1],
              ); // Automatically selecting the first example
            },
          ),
        );
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation Showcase'),
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: examples.length + 3,
        itemBuilder: (context, index) {
          if (index < examples.length) {
            return Hero(
              tag: 'example_${examples[index].title}',
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () async {
                    await Navigator.push<void>(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          if (examples[index].isFullScreen) {
                            return FullScreen(
                              key: UniqueKey(),
                              example: examples[index],
                            );
                          } else {
                            return DetailScreen(
                              key: UniqueKey(),
                              example: examples[index],
                            );
                          }
                        },
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.animation,
                        size: 48,
                        color: Colors.white70,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        examples[index].title,
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return SizedBox(
              height: MediaQuery.of(context).size.height, // Adjust this value as needed
              child: Container(), // Empty container for spacing
            );
          }
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.example});

  final AnimationExample example;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(example.title),
        elevation: 0,
        backgroundColor: example.appBarColor ?? Theme.of(context).primaryColor,
      ),
      body: Hero(
        tag: 'example_${example.title}',
        child: example.builder(context),
      ),
    );
  }
}

class FullScreen extends StatelessWidget {
  const FullScreen({super.key, required this.example});

  final AnimationExample example;

  @override
  Widget build(BuildContext context) {
    return example.builder(context);
  }
}
