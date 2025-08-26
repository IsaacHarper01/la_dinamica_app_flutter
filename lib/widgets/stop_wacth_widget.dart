import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

class   StopwatchWidget extends StatefulWidget {
  const StopwatchWidget({super.key});

  @override
  State<StopwatchWidget> createState() => _StopwatchWidgetState();
}

class _StopwatchWidgetState extends State<StopwatchWidget> {
  late Stopwatch _stopwatch;
  late final Ticker _ticker;
  String actualTime = "00:00:00.00";

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _ticker = Ticker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    if (_stopwatch.isRunning) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  String _formatTime(int milliseconds) {
    final int hundreds = (milliseconds / 10).truncate() % 100;
    final int seconds = (milliseconds / 1000).truncate() % 60;
    final int minutes = (milliseconds / (1000 * 60)).truncate() % 60;
    final int hours = (milliseconds / (1000 * 60 * 60)).truncate();

    final String hoursStr = (hours).toString().padLeft(2, '0');
    final String minutesStr = (minutes).toString().padLeft(2, '0');
    final String secondsStr = (seconds).toString().padLeft(2, '0');
    final String hundredsStr = (hundreds).toString().padLeft(2, '0');

    final String formattedTime = "$hoursStr:$minutesStr:$secondsStr.$hundredsStr";
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _formatTime(_stopwatch.elapsedMilliseconds),
          style: const TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_stopwatch.isRunning) {
                    _stopwatch.stop();
                  } else {
                    _stopwatch.start();
                  }
                });
              },
              child: Text(_stopwatch.isRunning ? 'Pausar' : 'Iniciar'),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _stopwatch.reset();
                });
              },
              child: const Text('Reiniciar'),
            ),
          ],
        ),
      ],
    );
  }
}