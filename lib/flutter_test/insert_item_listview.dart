import 'dart:math';

import 'package:flutter/material.dart';

class SomeListWidget extends StatefulWidget {
  const SomeListWidget({super.key});

  @override
  State<SomeListWidget> createState() => _SomeListWidgetState();
}

class _SomeListWidgetState extends State<SomeListWidget> {
  List<Color> colors = [
    Colors.red,
    Colors.green,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: colors.length,
              reverse: true,
              itemBuilder: (context, index) {
                return ColorTransitionBox(
                  targetColor: colors[index],
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final rnd = Random();
                final color = Color.fromARGB(
                    255, rnd.nextInt(256), rnd.nextInt(256), rnd.nextInt(256));
                colors.insert(0, color);
              });
            },
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
    }); // still needed this to initialize the color from the parent widget
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
