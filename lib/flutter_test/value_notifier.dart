import 'package:flutter/material.dart';

class ValueNotifierClass extends StatefulWidget {
  const ValueNotifierClass({super.key});

  @override
  State<ValueNotifierClass> createState() => _ValueNotifierClassState();
}

class _ValueNotifierClassState extends State<ValueNotifierClass> {
  final ValueNotifier<bool> test = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder<bool>(
                          valueListenable: test,
                          builder: (context, value, child) {
                return Text('Test is $value');
              }
            ),
            ElevatedButton(
                onPressed: () {
                  // setState(() {
                  //   testBool.value = !testBool.value;
                  // });
                   test.value = !test.value;
                },
                child: Text('Toggle bool'))
          ],
        ),
      ),
    );
  }
}
