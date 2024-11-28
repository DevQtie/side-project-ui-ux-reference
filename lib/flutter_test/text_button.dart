import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextButtonClass extends StatefulWidget {
  const TextButtonClass({super.key});

  @override
  State<TextButtonClass> createState() => _TextButtonClassState();
}

class _TextButtonClassState extends State<TextButtonClass> {
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(4),
      ),
    ),
    backgroundColor: Colors.greenAccent,
    foregroundColor: Colors.black,
  );

  Widget _customizedTextButton(Widget button) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border: Border.all(width: 1, color: Colors.black)),
      child: button,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 100,
          child: _customizedTextButton(
            TextButton(
              style: flatButtonStyle,
              onPressed: () {},
              child: Center(
                  child: Wrap(
                spacing: 8.0,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [Icon(CupertinoIcons.calendar_today), Text('Agenda')],
              )),
            ),
          ),
        ),
      ),
    );
  }
}
