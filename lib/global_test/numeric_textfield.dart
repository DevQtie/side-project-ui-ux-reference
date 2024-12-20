import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumericTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final VoidCallback? onEditingComplete;

  const NumericTextField({
    super.key,
    required this.controller,
    this.textInputAction = TextInputAction.done,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textInputAction: textInputAction,
      onEditingComplete: onEditingComplete,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
    );
  }
}
