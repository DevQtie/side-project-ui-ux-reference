import 'package:flutter/material.dart';

class ValueVerifier extends StatefulWidget {
  const ValueVerifier({super.key});

  @override
  State<ValueVerifier> createState() => _ValueVerifierState();
}

class _ValueVerifierState extends State<ValueVerifier> {
  final _txtEcontroller = TextEditingController();
  bool _isInputEmpty = true;

  void _handleTextChange() {
    if (mounted) {
      setState(() {
        _isInputEmpty = _txtEcontroller.text.isEmpty;
      });

      Future.delayed(const Duration(milliseconds: 3000), () {
        setState(() {});
      });
    }
  }

  @override
  void initState() {
    _txtEcontroller.addListener(_handleTextChange);
    super.initState();
  }

  @override
  void dispose() {
    _txtEcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isInputEmpty ? Colors.grey : Colors.black,
      appBar: AppBar(
        title: Text('test'),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: TextField(
          style: TextStyle(color: Colors.black),
          controller: _txtEcontroller,
        ),
      ),
    );
  }
}
