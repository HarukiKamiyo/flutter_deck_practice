import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterDeckApp(
      configuration: FlutterDeckConfiguration(
        footer: FlutterDeckFooterConfiguration(
          showSlideNumbers: true,
        ),
      ),
      slides: [
        TitleSlide(),
      ],
    );
  }
}

class TitleSlide extends FlutterDeckSlideWidget {
  const TitleSlide({super.key})
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/title',
            title: 'タイトルスライド',
            footer: FlutterDeckFooterConfiguration(showFooter: false),
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.title(
      title: 'Flutter Deck 入門',
      subtitle: 'Flutterでスライドを作ってみよう！',
    );
  }
}
