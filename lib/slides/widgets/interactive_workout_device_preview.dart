import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';

class InteractiveWorkoutDevicePreview extends StatefulWidget {
  const InteractiveWorkoutDevicePreview({super.key});

  @override
  State<InteractiveWorkoutDevicePreview> createState() =>
      _InteractiveWorkoutDevicePreviewState();
}

class _InteractiveWorkoutDevicePreviewState
    extends State<InteractiveWorkoutDevicePreview> {
  bool _isIos = true;
  double _weight = 80.0;
  int _sets = 3;
  bool _isCompleted = false;

  @override
  Widget build(BuildContext context) {
    final totalVolume = (_sets * 10 * _weight).toInt();

    return Column(
      children: [
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

