import 'package:flutter/material.dart';

class DataChecker extends StatefulWidget {
  const DataChecker({super.key});

  @override
  State<DataChecker> createState() => _DataCheckerState();
}

class _DataCheckerState extends State<DataChecker> {
  String? situation;

  @override
  void initState() {
    super.initState();
    situation = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Checker Test'),
      ),
      body: ElevatedButton(
        onPressed: () {
          setState(() {
            situation = '';
            debugPrint(situation);
          });
        },
        child: situation == null ? Text('Test Data') : Text('IsNull'),
      ),
    ); // invalid setup
  }
}
