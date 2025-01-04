import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String text =
      'Von morgens bis mittags begrüßt man sich mit %d¡Buenos dias!%d \n Danach bis zum Einbruch der Dunkelheit mit %d¡Buenas tardes!%d \nAb dann begrüßt und verabschiedet man sich mit ¡Buenas noches!. \nIn informellen Situationen kann man auch einfach %d¡Hola!%d sagen. \nUmgangssprachlich wird oft auch nur %d¡Buenas!%d verwendet.';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Linebreak'),
      ),
      body: Center(
          child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: CustomMarkupText(text))),
    );
  }
}

class CustomMarkupText extends StatelessWidget {
  final String text;

  const CustomMarkupText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final spans = _parseMarkup(text);
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 16, color: Colors.black),
        children: spans,
      ),
    );
  }

  List<TextSpan> _parseMarkup(String text) {
    final spans = <TextSpan>[];
    final regex = RegExp(r'%r(.*?)%r|%d(.*?)%d|([^%]+)');
    final matches = regex.allMatches(text);

    for (var match in matches) {
      if (match.group(1) != null) {
        // %Rroter Text%R
        spans.add(TextSpan(
          text: match.group(1),
          style: TextStyle(color: Colors.red),
        ));
      } else if (match.group(2) != null) {
        // %Bfetter Text%B
        spans.add(TextSpan(
          text: match.group(2),
          style: TextStyle(fontWeight: FontWeight.bold),
        ));
      } else if (match.group(3) != null) {
        // Normaler Text (ohne Markup)
        spans.add(TextSpan(text: match.group(3)));
      }
    }

    return spans;
  }
}
