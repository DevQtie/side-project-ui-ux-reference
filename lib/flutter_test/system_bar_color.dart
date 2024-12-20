import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PractiseScreen extends StatelessWidget {
  const PractiseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Color color = const Color(0xE8024585);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: color,
        statusBarBrightness: Brightness.light, // Status bar icons (for iOS)
        statusBarIconBrightness:
            Brightness.dark, // Status bar icons (for Android)
      ),
    );

    return Container(
      color: color,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: color,
          body: Container(
            color: color,
            child: Center(
              child: Text(
                'Safearea is darker than scaffod',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
