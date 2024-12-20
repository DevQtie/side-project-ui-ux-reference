import 'dart:math';

import 'package:flutter/material.dart';

class SomeListWidget2 extends StatefulWidget {
  const SomeListWidget2({super.key});

  @override
  State<SomeListWidget2> createState() => _SomeListWidget2State();
}

class _SomeListWidget2State extends State<SomeListWidget2> {
  // List<Color> colors = [
  //   Colors.red,
  //   Colors.green,
  // ]; // from this

  List<Map<String, dynamic>> colorsList = [
    {'id': 1, 'color': Colors.red},
    {'id': 2, 'color': Colors.green}
  ]; //try this instead

  void rearrangeColors() {
    final rnd = Random();
    final color = Color.fromARGB(
        254, rnd.nextInt(256), rnd.nextInt(256), rnd.nextInt(256));
    Map<String, dynamic> firstItem = colorsList.first;
    int newId = firstItem['id'] - 1;
    setState(() {
      colorsList.insert(0, {
        'id': newId,
        'color': color,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: colorsList.length,
              shrinkWrap: true,
              reverse: true,
              itemBuilder: (context, index) {
                // Sort the list based on 'id' field each time the item is rendered
                List<Map<String, dynamic>> sortedColors;

                sortedColors = List.from(colorsList)
                  ..sort((a, b) => a['id'].compareTo(b['id']));
                Color value = sortedColors[index]['color'];
                return ColorTransitionBox(
                  targetColor: value,
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: rearrangeColors,
            child: Text('Add color'),
          ),
        ],
      ),
    );
  }
}

class ColorTransitionBox extends StatefulWidget {
  final Color? targetColor;

  const ColorTransitionBox({super.key, required this.targetColor});

  @override
  State<ColorTransitionBox> createState() => _ColorTransitionBoxState();
}

class _ColorTransitionBoxState extends State<ColorTransitionBox> {
  Color? currentColor;

  @override
  void initState() {
    super.initState();
    // Start the color transition after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          currentColor = widget.targetColor;
        });
      }
    }); // needed this to initialize the color from the parent widget
  }

  @override
  void didUpdateWidget(covariant ColorTransitionBox oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.targetColor != oldWidget.targetColor) {
      currentColor = widget.targetColor;
    } // to sync the newly added dynamic color
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      curve: Curves.linear, // Linear animation
      color: currentColor,
      width: 100, // Example width
      height: 100, // Example height
      child: Center(
        child: Text(
          'Color Box',
          style: TextStyle(
            color: currentColor == Colors.white ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}
