import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import 'slides/01_title_slide.dart';
import 'slides/02_live_device_demo_slide.dart';
import 'slides/03_steps_animation_slide.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterDeckApp(
      configuration: FlutterDeckConfiguration(
        // スライドを常に「16:9（Full HD 1920×1080）」の比率に固定
        // 画面サイズ（PC、iPad、スマホ縦・横）に合わせて自動で等倍スケーリングされる
        slideSize: FlutterDeckSlideSize.fromAspectRatio(
          aspectRatio: FlutterDeckAspectRatio.ratio16x9(),
          resolution: const FlutterDeckResolution.fhd(),
        ),
        footer: const FlutterDeckFooterConfiguration(showSlideNumbers: true),
      ),
      slides: const [
        TitleSlide(),
        LiveDeviceDemoSlide(),
        StepsAnimationSlide(),
      ],
    );
  }
}
