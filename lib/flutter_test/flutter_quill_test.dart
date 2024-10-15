import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_observer/main.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class FlutterQuillTest extends StatefulWidget {
  const FlutterQuillTest({super.key});

  @override
  State<FlutterQuillTest> createState() => _FlutterQuillTestState();
}

class _FlutterQuillTestState extends State<FlutterQuillTest> {
  final _wYSIWYGTextEditorControllerComposed = quill.QuillController.basic();
  final _wYSIWYGTextEditorControllerExtract = quill.QuillController.basic();
  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).extension<CustomTheme>();
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    final bool isDarkMode = brightness == Brightness.dark;

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
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Source Text',
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              LayoutBuilder(
                builder: (context, constraint) {
                  double parentWidth = constraint.maxWidth;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                        padding: const EdgeInsets.all(8.0),
                        width: parentWidth,
                        decoration: BoxDecoration(
                          color: customTheme?.containerBackgroundColor,
                          borderRadius:
                              BorderRadius.circular(10.0), // Border radius
                          border: Border.all(
                              color: isDarkMode
                                  ? const Color.fromARGB(170, 255, 193, 7)
                                  : Colors.lightBlue), // Border color
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                              primaryColor: Colors.black,
                              colorScheme: isDarkMode
                                  ? ColorScheme.dark(
                                      surface: Colors.grey.shade900)
                                  : ColorScheme.light(
                                      surface: Colors.grey.shade300)),
                          child: quill.QuillToolbar.simple(
                            controller: _wYSIWYGTextEditorControllerComposed,
                            configurations:
                                const quill.QuillSimpleToolbarConfigurations(
                              showDividers: true,
                              showAlignmentButtons: true,
                              showInlineCode: false,
                              showCodeBlock: false,
                              showFontFamily: true,
                              showColorButton: false,
                              showBackgroundColorButton: false,
                              showSearchButton: false,
                              showQuote: false,
                              showSubscript: false,
                              showStrikeThrough: false,
                              sectionDividerColor:
                                  Color.fromARGB(170, 255, 193, 7),
                              sectionDividerSpace: 5.0,
                              toolbarSectionSpacing: 5.0,
                            ),
                          ),
                        ),
                      ), //for viewing of created flutter_quill text, don't show the QuillToolbar
                      Container(
                        width: parentWidth,
                        height: 400,
                        margin: const EdgeInsets.only(bottom: 8.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: customTheme?.containerBackgroundColor,
                          borderRadius:
                              BorderRadius.circular(10.0), // Border radius
                          border: Border.all(
                              color: isDarkMode
                                  ? const Color.fromARGB(170, 255, 193, 7)
                                  : Colors.lightBlue), // Border color
                        ),
                        child: quill.QuillEditor.basic(
                          controller: _wYSIWYGTextEditorControllerComposed,
                          configurations: quill.QuillEditorConfigurations(
                              padding: const EdgeInsets.all(8.0),
                              disableClipboard: false,
                              maxContentWidth: parentWidth,
                              minHeight: 200,
                              maxHeight: 400,
                              sharedConfigurations: const quill
                                  .QuillSharedConfigurations(
                                  locale: Locale(
                                      'en_US'))), //make this as ready-only if only showing a created flutter_quill text
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      quill.QuillEditor.basic(
                        controller: _wYSIWYGTextEditorControllerExtract,
                        configurations: quill.QuillEditorConfigurations(
                            padding: const EdgeInsets.all(8.0),
                            disableClipboard: true,
                            maxContentWidth: parentWidth,
                            minHeight: 200,
                            sharedConfigurations: const quill
                                .QuillSharedConfigurations(
                                locale: Locale(
                                    'en_US'))), //make this as ready-only if only showing a created flutter_quill text
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final delta = _wYSIWYGTextEditorControllerComposed
                                .document
                                .toDelta();
                            final json = jsonDecode(jsonEncode(delta.toJson()));
                            // final plainText =
                            //     _wYSIWYGTextEditorControllerComposed.document
                            //         .toPlainText(); // for plain text
                            setState(() {
                              // Ensure the selection offset is valid
                              // int insertOffset =
                              //     _wYSIWYGTextEditorControllerExtract
                              //         .selection.baseOffset;

                              // if (insertOffset == -1) {
                              //   // Default to appending at the end if selection is invalid
                              //   insertOffset =
                              //       _wYSIWYGTextEditorControllerExtract
                              //           .document.length;
                              // }
                              // _wYSIWYGTextEditorControllerExtract.document
                              //     .insert(insertOffset, plainText); // for plain text
                              _wYSIWYGTextEditorControllerExtract.document =
                                  quill.Document.fromJson(json);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                          ),
                          child: Text(
                            'Generate Quill Data',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
