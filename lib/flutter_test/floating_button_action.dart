import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Flutter code sample for [FloatingActionButton].

void main() {
  runApp(const FloatingActionButtonExampleApp());
}

class FloatingActionButtonExampleApp extends StatelessWidget {
  const FloatingActionButtonExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const FloatingActionButtonExample(),
    );
  }
}

class FloatingActionButtonExample extends StatefulWidget {
  const FloatingActionButtonExample({super.key});

  @override
  State<FloatingActionButtonExample> createState() =>
      _FloatingActionButtonExampleState();
}

class _FloatingActionButtonExampleState
    extends State<FloatingActionButtonExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FloatingActionButton Sample'),
      ),
      body: const Center(child: Text('Press the button below!')),
      floatingActionButton: SizedBox(
        height: 35,
        width: 35,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              debugPrint('Hi I am DevQt');
            });
          },
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.transparent, width: 2.0),
            borderRadius: BorderRadius.circular(35),
          ),
          child: const Icon(
            CupertinoIcons.stop,
            grade: 5.0,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 67.0,
        notchMargin: 6.0,
        shape: const CircularNotchedRectangle(),
        color: Colors.amberAccent,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: IconButton(
                    iconSize: 25,
                    onPressed: () {},
                    icon: Icon(CupertinoIcons.speaker),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'End Session',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: IconButton(
                    iconSize: 25,
                    onPressed: () {},
                    icon: Icon(CupertinoIcons.video_camera),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
