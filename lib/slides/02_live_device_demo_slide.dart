import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import 'widgets/interactive_workout_device_preview.dart';

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
      rightBuilder: (context) => const InteractiveWorkoutDevicePreview(),
    );
  }
}

