import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

class StepsAnimationSlide extends FlutterDeckSlideWidget {
  const StepsAnimationSlide({super.key})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/steps-animation',
          title: 'ステップ連動アニメーション',
          steps: 4, // 矢印キー（→）で 1 → 2 → 3 → 4 と4段階進む
          header: FlutterDeckHeaderConfiguration(
            title: 'キーボード（→）と連動するステップ＆アニメーション',
          ),
        ),
      );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => FlutterDeckSlideStepsBuilder(
        builder: (context, stepNumber) {
          final currentStep = stepNumber.clamp(1, 4);

          final bulletItems = const [
            'Step 1: スライド設定に steps: 4 を指定するだけ',
            'Step 2: 矢印キー（→）でページ遷移せずステップが進む',
            'Step 3: ステップ番号に応じてグラフや図解がリアルタイム変形！',
            'Step 4: パワポの複雑なアニメ設定なしでコードで完全制御 🚀',
          ];

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 左側：FlutterDeckBulletListのAutoSizeText内部バグを回避し、自前でステップ表示
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < bulletItems.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: currentStep >= (i + 1) ? 1.0 : 0.0,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '•',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    bulletItems[i],
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // 右側：currentStep に応じてリアルタイムに伸びるアニメーション棒グラフ
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '現在のステップ: $currentStep / 4',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 32),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final maxHeight = constraints.maxHeight;
                            // 棒グラフ以外の文字や余白（約60px）を引いた有効高さ
                            final usableHeight = (maxHeight - 60).clamp(
                              30.0,
                              maxHeight,
                            );
                            final targetHeights = [
                              usableHeight * 0.25,
                              usableHeight * 0.45,
                              usableHeight * 0.70,
                              usableHeight * 0.95,
                            ];
                            final labels = ['企画', 'UI実装', 'アニメ連動', 'Web公開'];

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: List.generate(4, (index) {
                                final isReached = currentStep >= (index + 1);

                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AnimatedOpacity(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      opacity: isReached ? 1.0 : 0.2,
                                      child: Text(
                                        isReached ? 'DONE!' : '...',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      curve: Curves.easeInOut,
                                      width: 60,
                                      height: isReached
                                          ? targetHeights[index]
                                          : 20,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: isReached
                                              ? [
                                                  Colors.indigo,
                                                  Colors.cyanAccent.shade700,
                                                ]
                                              : [
                                                  Colors.grey.shade600,
                                                  Colors.grey.shade400,
                                                ],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      labels[index],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
