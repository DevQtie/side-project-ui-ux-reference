import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class StopwatchService {
  final StreamController<Duration> _elapsedTimeController = StreamController<Duration>.broadcast();
  final StreamController<Duration> _lapTimeController = StreamController<Duration>.broadcast();

  Duration _pausedDuration = Duration.zero;
  int? _startTimeEpoch;
  int? _lastStopTimeEpoch;

  Stream<Duration> get elapsedTimeStream => _elapsedTimeController.stream;
  Stream<Duration> get lapTimeStream => _lapTimeController.stream;

  void start() {
    _startTimeEpoch ??= DateTime.now().millisecondsSinceEpoch;
    _tick();
  }

  void stop() {
    _lastStopTimeEpoch = DateTime.now().millisecondsSinceEpoch;
    _pausedDuration += Duration(milliseconds: _lastStopTimeEpoch! - _startTimeEpoch!);
    _elapsedTimeController.add(_pausedDuration);
    _lapTimeController.add(Duration.zero); // For simplicity
  }

  void reset() {
    _elapsedTimeController.add(Duration.zero);
    _lapTimeController.add(Duration.zero);
  }

  Future<void> loadState(SharedPreferences prefs) async {
    final lastStopTimeEpoch = prefs.getInt('lastStopTimeEpoch') ?? DateTime.now().millisecondsSinceEpoch;
    final startTimeEpoch = prefs.getInt('startTimeEpoch') ?? 0;
    final pausedDuration = Duration(milliseconds: prefs.getInt('pausedDuration') ?? 0);

    if (startTimeEpoch != 0) {
      final elapsedTime = Duration(milliseconds: lastStopTimeEpoch - startTimeEpoch - pausedDuration.inMilliseconds);
      _elapsedTimeController.add(elapsedTime);
      _lapTimeController.add(Duration.zero);
    }
  }

  void _tick() {
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (_startTimeEpoch == null) return;
      final now = DateTime.now().millisecondsSinceEpoch;
      final elapsedTime = Duration(milliseconds: now - _startTimeEpoch! - _pausedDuration.inMilliseconds);
      _elapsedTimeController.add(elapsedTime);
    });
  }
}