import 'package:flutter/material.dart';

class RowTextFields extends StatefulWidget {
  const RowTextFields({super.key});

  @override
  State<RowTextFields> createState() => _RowTextFieldsState();
}

class _RowTextFieldsState extends State<RowTextFields> {
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Row TextField'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: TextField(
                  focusNode: _focusNode1,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: TextField(
                  focusNode: _focusNode1,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                ),
              ),
            ),
            TextButton(
              onPressed: FocusScope.of(context).unfocus,
              child: const Text('Unfocus'),
            )
          ],
        ),
      ),
    );
  }
}
