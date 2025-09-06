import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import 'package:la_dinamica_app/providers/stop_watch_provider.dart';

class StopwatchNotifier extends StateNotifier<String> {
  final Stopwatch _stopwatch = Stopwatch();
  late final Ticker _ticker;

  StopwatchNotifier() : super("00:00:00.00") {
    _ticker = Ticker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    if (_stopwatch.isRunning) {
      state = _formatTime(_stopwatch.elapsedMilliseconds);
    }
  }

  void startStop() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
    } else {
      _stopwatch.start();
    }
  }

  void reset() {
    _stopwatch.reset();
    state = "00:00:00.00";
  }

  String get currentTime => _formatTime(_stopwatch.elapsedMilliseconds);

  String _formatTime(int milliseconds) {
    final hundreds = (milliseconds / 10).truncate() % 100;
    final seconds = (milliseconds / 1000).truncate() % 60;
    final minutes = (milliseconds / (1000 * 60)).truncate() % 60;
    final hours = (milliseconds / (1000 * 60 * 60)).truncate();

    final hoursStr = hours.toString().padLeft(2, '0');
    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = seconds.toString().padLeft(2, '0');
    final hundredsStr = hundreds.toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr.$hundredsStr";
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}

class StopwatchWidget extends ConsumerWidget {
  const StopwatchWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final time = ref.watch(stopwatchProvider);
    final notifier = ref.read(stopwatchProvider.notifier);
    final Orientation orientation = MediaQuery
        .of(context)
        .orientation;
    final bool isPortatil = orientation == Orientation.portrait;
    final screenHeight = isPortatil ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height * 2;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            time,
            style: TextStyle(fontSize: screenHeight * 0.03, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: notifier.startStop,
                child: Text(ref.read(stopwatchProvider.notifier)._stopwatch.isRunning
                    ? 'Pausar'
                    : 'Iniciar'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: notifier.reset,
                child: const Text('Reiniciar'),
              ),
            ],
          ),
        ],
    );
  }
}
