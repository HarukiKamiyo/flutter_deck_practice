import 'package:device_frame/device_frame.dart';
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
        footer: const FlutterDeckFooterConfiguration(
          showSlideNumbers: true,
        ),
      ),
      slides: const [
        TitleSlide(),
        LiveDeviceDemoSlide(),
        StepsAnimationSlide(),
      ],
    );
  }
}

/// 1枚目：タイトルスライド
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
      subtitle: 'パワポでは出来ないインタラクティブ体験！',
    );
  }
}

/// 2枚目：左にスクロール可能なコード、右に device_frame のライブデモ
class LiveDeviceDemoSlide extends FlutterDeckSlideWidget {
  const LiveDeviceDemoSlide({super.key})
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/live-device-demo',
            title: 'コード＆実機フレームデモ',
            header: FlutterDeckHeaderConfiguration(
              title: 'スクロールできるコード ＆ DeviceFrame ライブデモ',
            ),
          ),
        );

  static const _sampleCode = '''
class WorkoutTrackerDemo extends StatefulWidget {
  const WorkoutTrackerDemo({super.key});

  @override
  State<WorkoutTrackerDemo> createState() => _WorkoutTrackerDemoState();
}

class _WorkoutTrackerDemoState extends State<WorkoutTrackerDemo> {
  int _sets = 3;
  double _weight = 80.0;
  bool _isCompleted = false;

  @override
  Widget build(BuildContext context) {
    final totalVolume = (_sets * 10 * _weight).toInt();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Logger 🏋️'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 重量スライダー（リアルタイムに総負荷量が変化）
            Slider(
              value: _weight,
              min: 20,
              max: 150,
              divisions: 26,
              onChanged: (v) => setState(() => _weight = v),
            ),
            // セット数カウンター
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => setState(() => _sets--),
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text('\$_sets Sets × 10 Reps'),
                IconButton(
                  onPressed: () => setState(() => _sets++),
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            // アニメーション付き総ボリューム表示
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _isCompleted ? Colors.green : Colors.indigo,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text('Total Volume: \$totalVolume kg'),
            ),
          ],
        ),
      ),
    );
  }
}''';

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const SingleChildScrollView(
          child: FlutterDeckCodeHighlight(
            fileName: 'workout_tracker_demo.dart',
            code: _sampleCode,
          ),
        ),
      ),
      rightBuilder: (context) => const _InteractiveDevicePreview(),
    );
  }
}

/// スライド右半分に表示する DeviceFrame + 実際に触れるミニアプリ
class _InteractiveDevicePreview extends StatefulWidget {
  const _InteractiveDevicePreview();

  @override
  State<_InteractiveDevicePreview> createState() =>
      _InteractiveDevicePreviewState();
}

class _InteractiveDevicePreviewState extends State<_InteractiveDevicePreview> {
  bool _isIos = true;
  double _weight = 80.0;
  int _sets = 3;
  bool _isCompleted = false;

  @override
  Widget build(BuildContext context) {
    final totalVolume = (_sets * 10 * _weight).toInt();

    return Column(
      children: [
        // スライド上で iPhone / Android をその場で切り替えられるボタン
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(
              value: true,
              icon: Icon(Icons.phone_iphone),
              label: Text('iPhone 13'),
            ),
            ButtonSegment(
              value: false,
              icon: Icon(Icons.phone_android),
              label: Text('Android'),
            ),
          ],
          selected: {_isIos},
          onSelectionChanged: (selected) {
            setState(() => _isIos = selected.first);
          },
        ),
        const SizedBox(height: 16),
        // DeviceFrame 本体
        Expanded(
          child: Center(
            child: DeviceFrame(
              device: _isIos
                  ? Devices.ios.iPhone13
                  : Devices.android.samsungGalaxyS20,
              screen: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  colorSchemeSeed: Colors.indigo,
                  useMaterial3: true,
                ),
                home: Scaffold(
                  appBar: AppBar(
                    title: const Text('Workout Logger 🏋️'),
                    centerTitle: true,
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Bench Press: ${_weight.toInt()} kg',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Slider(
                          value: _weight,
                          min: 20,
                          max: 150,
                          divisions: 26,
                          label: '${_weight.toInt()} kg',
                          onChanged: (value) {
                            setState(() => _weight = value);
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton.filledTonal(
                              onPressed: _sets > 1
                                  ? () => setState(() => _sets--)
                                  : null,
                              icon: const Icon(Icons.remove),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                '$_sets Sets × 10 Reps',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            IconButton.filledTonal(
                              onPressed: () => setState(() => _sets++),
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutBack,
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: _isCompleted
                                ? Colors.teal.shade600
                                : Colors.indigo.shade600,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: (_isCompleted
                                        ? Colors.teal
                                        : Colors.indigo)
                                    .withValues(alpha: 0.4),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'TOTAL VOLUME',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$totalVolume kg',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        FilledButton.icon(
                          onPressed: () {
                            setState(() => _isCompleted = !_isCompleted);
                          },
                          icon: Icon(
                            _isCompleted
                                ? Icons.check_circle
                                : Icons.fitness_center,
                          ),
                          label: Text(
                            _isCompleted ? 'ワークアウト完了！🔥' : 'セットを記録する',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 3枚目：矢印キー（→）を押すたびにステップとアニメーションが進むスライド
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
          return Row(
            children: [
              // 左側：ステップごとに1行ずつ表示される箇条書き
              Expanded(
                child: FlutterDeckBulletList(
                  useSteps: true,
                  items: const [
                    'Step 1: スライド設定に steps: 4 を指定するだけ',
                    'Step 2: 矢印キー（→）でページ遷移せずステップが進む',
                    'Step 3: ステップ番号に応じてグラフや図解がリアルタイム変形！',
                    'Step 4: パワポの複雑なアニメ設定なしでコードで完全制御 🚀',
                  ],
                ),
              ),
              const SizedBox(width: 48),
              // 右側：stepNumber に応じてリアルタイムに伸びるアニメーション棒グラフ
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                        .withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '現在のステップ: $stepNumber / 4',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 32),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(4, (index) {
                            final isReached = stepNumber >= (index + 1);
                            final heights = [90.0, 160.0, 240.0, 320.0];
                            final labels = ['企画', 'UI実装', 'アニメ連動', 'Web公開'];

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                AnimatedOpacity(
                                  duration: const Duration(milliseconds: 300),
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
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.elasticOut,
                                  width: 64,
                                  height: isReached ? heights[index] : 24,
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
