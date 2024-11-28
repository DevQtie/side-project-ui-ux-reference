import 'dart:convert';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/main.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:developer' as developer;

class FlutterQuillTest3 extends StatefulWidget {
  const FlutterQuillTest3({super.key});

  @override
  State<FlutterQuillTest3> createState() => _FlutterQuillTest3State();
}

class _FlutterQuillTest3State extends State<FlutterQuillTest3> {
  final __contentDecoderController = quill.QuillController.basic();

  final quillFocusNode = FocusNode();

  ///Map of font families in string
  Map<String, String>? fontFamilies = {
    'Roboto': 'roboto',
    'Open Sans': 'open-sans',
    'Lato': 'lato',
    'Montserrat': 'montserrat',
    'Roboto Condensed': 'roboto-condensed',
    'Oswald': 'oswald',
    'Poppins': 'poppins',
    'Slabo 27px': 'slabo-27px',
    'NotoSans': 'noto-sans',
    'Roboto Mono': 'roboto-mono',
    'Merriweather': 'merriweather',
    'Clear': 'Clear'
  };

  final List<String> imageFileExtensions = [
    '.jpeg',
    '.jpg',
    '.png',
  ];
  final textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    quillFocusNode.canRequestFocus = false;
  }

  @override
  void dispose() {
    __contentDecoderController.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  /// [test1.test2]
  /// [test2] // manual setting of method reference
  void test1() { //method 1
    debugPrint('this is a test 1');
    test2();
  }

  /// [test3] // manual setting of method reference
  void test2() { //method 2
    debugPrint('this is a test 2');
    test3();
  }

  /// [test1],[test2] // manual setting of method references
  void test3() { //method 3
    debugPrint('this is a test 3');
    test1();
    test2();
  }

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).extension<CustomTheme>();
    double bottomPadding = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flutter Quill Test',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.normal),
        ),
        forceMaterialTransparency: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: customTheme?.containerBackgroundColor,
          borderRadius: BorderRadius.circular(10.0), // Border radius
          border: Border.all(color: Colors.transparent), // Border color
        ),
        // padding: const EdgeInsets.all(15.0),
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  child: Text('Generated Content',
                      textAlign: TextAlign.start,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                ),
              ),
              quill.QuillEditor.basic(
                focusNode: quillFocusNode,
                controller: __contentDecoderController,
                configurations: quill.QuillEditorConfigurations(
                    embedBuilders: kIsWeb
                        ? FlutterQuillEmbeds.editorWebBuilders(
                            videoEmbedConfigurations: null,
                          )
                        : FlutterQuillEmbeds.editorBuilders(
                            videoEmbedConfigurations: null,
                          ),
                    padding: const EdgeInsets.all(8.0),
                    disableClipboard: true,
                    maxContentWidth: MediaQuery.of(context).size.width,
                    minHeight: 200,
                    sharedConfigurations: const quill.QuillSharedConfigurations(
                        locale: Locale(
                            'en_US'))), //make this as ready-only if only showing a created flutter_quill text
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                key: const ValueKey('jsonData'),
                controller: textEditingController,
                readOnly: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      final json = jsonDecode(textEditingController.text);
                      __contentDecoderController.document =
                          quill.Document.fromJson(json);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  child: Text(
                    'Preview Quill Data',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
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

class ClassA {
  void methodA1() {
    debugPrint("Test ClassA's method 1");
  }
}

class ClassC {
  void methodA1() {
    debugPrint("Test ClassC's method 1");
  }
}

class ClassB {
    /// [ClassA.methodA1]
  void methodB1() {
    ClassA().methodA1();
  }
}