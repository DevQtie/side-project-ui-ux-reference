import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'dart:developer' as developer;

class HeightInspector extends StatefulWidget {
  //has exception to observe
  const HeightInspector({super.key});

  @override
  State<HeightInspector> createState() => _HeightInspectorState();
}

class _HeightInspectorState extends State<HeightInspector> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set the system UI overlay style (status bar)
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     statusBarColor: isScrolledHeader
    //         ? Colors.transparent
    //         : Color.fromARGB(190, 255, 193, 7)
    //             .withOpacity(0.3), // Makes the status bar transparent
    //     statusBarBrightness: Brightness.light, // Status bar icons (for iOS)
    //     statusBarIconBrightness:
    //         Brightness.dark, // Status bar icons (for Android)
    //   ),
    // );

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('My App'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Tab 1'),
              Tab(text: 'Tab 2'),
              Tab(text: 'Tab 3'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 4250, //MediaQuery.of(context).size.height,
                        width: double.infinity,
                        color: Colors.redAccent,
                        child: Text('Tab 3 Content')),
                  ],
                ),
              ),
            ),
            Center(
                child: Container(
                    height: 200,
                    color: Colors.redAccent,
                    child: Center(child: Text('Tab 1 Content')))),
            Center(
                child: Container(
                    height: 400,
                    color: Colors.greenAccent,
                    child: Center(child: Text('Tab 2 Content')))),
          ],
        ),
      ),
    );
  }
}
