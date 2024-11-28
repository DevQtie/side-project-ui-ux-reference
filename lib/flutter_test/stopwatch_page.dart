import 'package:flutter/material.dart';
import 'package:flutter_observer/other_class_test/stopwatch_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  StopwatchPageState createState() => StopwatchPageState();
}

class StopwatchPageState extends State<StopwatchPage> {
  final StopwatchService _stopwatchService = StopwatchService();
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadState();
  }

  Future<void> _loadState() async {
    await _stopwatchService.loadState(_prefs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<Duration>(
              stream: _stopwatchService.elapsedTimeStream,
              builder: (context, snapshot) {
                final elapsed = snapshot.data ?? Duration.zero;
                return Text(elapsed.toString());
              },
            ),
            ElevatedButton(
              onPressed: () {
                _stopwatchService.start();
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Start',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _stopwatchService.stop();
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Pause',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _stopwatchService.reset();
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Reset',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
