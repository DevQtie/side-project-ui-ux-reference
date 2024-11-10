import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class Widget1 extends StatefulWidget {
  const Widget1({super.key});

  @override
  State<Widget1> createState() => _Widget1State();
}

class _Widget1State extends State<Widget1> {
  @override
  void didChangeDependencies() {
    if (mounted) {
      developer.log('Current widget in the widget tree in Widget1 class test');
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return const Widget2();
  }
}

class Widget2 extends StatefulWidget {
  const Widget2({super.key});

  @override
  State<Widget2> createState() => _Widget2State();
}

class _Widget2State extends State<Widget2> {
  @override
  void didChangeDependencies() {
    if (mounted) {
      developer.log('Current widget in the widget tree in Widget2 class test');
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.viewInsetsOf(context).bottom;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Hello World",
                textDirection: TextDirection.ltr,
              ),
              Container(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Put some text',
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
