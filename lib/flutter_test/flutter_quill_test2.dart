import 'dart:convert';
import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/main.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:flutter/foundation.dart' show Uint8List, compute, kIsWeb;
import 'dart:developer' as developer;

class FlutterQuillTest2 extends StatefulWidget {
  const FlutterQuillTest2({super.key});

  @override
  State<FlutterQuillTest2> createState() => _FlutterQuillTest2State();
}

class _FlutterQuillTest2State extends State<FlutterQuillTest2> {
  final _contentGeneratorController = quill.QuillController.basic();

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

  String documentJson = '';
  final textEditingController = TextEditingController();

  Future<void> insertBase64Image(DropItem file) async {
    try {
      // Convert the file to a Base64-encoded string
      // final bytes = await file.readAsBytes();
      // final base64String = base64Encode(bytes); // need to refactor

      // Convert the file to a Base64-encoded string asynchronously
      final base64String =
          await compute(_convertToBase64, await file.readAsBytes());

      // Construct the Base64 image source
      final imageSource =
          'data:image/png;base64,$base64String'; // Adjust MIME type if necessary (e.g., `image/jpeg`)

      // Insert the image using the Base64 string
      _contentGeneratorController.insertImageBlock(imageSource: imageSource);
    } catch (e) {
      // Handle any errors gracefully
      debugPrint('Error inserting image: $e');
    }
  }

// Helper function for Base64 conversion (runs in an isolate to avoid UI blocking)
  String _convertToBase64(Uint8List bytes) => base64Encode(bytes);

  OnDragDoneCallback get _onDragDone {
    return (details) async {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final file = details.files.first;
      final isSupported =
          imageFileExtensions.any((ext) => file.name.endsWith(ext));
      if (!isSupported) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            duration: const Duration(milliseconds: 3000),
            content: Text(
              'Only images are supported right now: ${file.mimeType}, ${file.name}, ${file.path}, $imageFileExtensions',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        );
        return;
      }
      Future<int> fileSize = file.length();
      developer.log('File size: ${await fileSize / 1000 / 1000}');
      final isValidSize = 3 >= await fileSize / 1000 / 1000;
      if (!isValidSize) {
        if (mounted) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              duration: const Duration(milliseconds: 3000),
              content: Text(
                'Only file size supported right now: Maximum of 3 MB',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          );
          return;
        }
      }
      // To get this extension function please import flutter_quill_extensions
      _contentGeneratorController.insertImageBlock(
        imageSource: file.path,
      );
      // await insertBase64Image(file);
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Image is inserted.'),
        ),
      );
    };
  }

  @override
  void initState() {
    super.initState();
    quillFocusNode.canRequestFocus = false;
  }

  @override
  void dispose() {
    _contentGeneratorController.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).extension<CustomTheme>();
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    final bool isDarkMode = brightness == Brightness.dark;
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Source Content',
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ),
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
                            controller: _contentGeneratorController,
                            configurations:
                                quill.QuillSimpleToolbarConfigurations(
                              dialogTheme: quill.QuillDialogTheme(
                                dialogBackgroundColor: isDarkMode
                                    ? Colors.grey.shade900
                                    : Colors.grey.shade100,
                              ),
                              embedButtons: FlutterQuillEmbeds.toolbarButtons(
                                // imageButtonOptions: null,
                                cameraButtonOptions: null,
                                videoButtonOptions: null,
                              ),
                              fontFamilyValues: fontFamilies,
                              showFontFamily: true,
                              showDividers: true,
                              showAlignmentButtons: true,
                              showInlineCode: false,
                              showCodeBlock: false,
                              showColorButton: false,
                              showBackgroundColorButton: false,
                              showSearchButton: false,
                              showQuote: false,
                              showSubscript: false,
                              showStrikeThrough: false,
                              sectionDividerColor:
                                  const Color.fromARGB(170, 255, 193, 7),
                              sectionDividerSpace: 5.0,
                              toolbarSectionSpacing: 5.0,
                            ),
                          ),
                        ),
                      ),
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
                          controller: _contentGeneratorController,
                          configurations: quill.QuillEditorConfigurations(
                            builder: (context, rawEditor) {
                              return DropTarget(
                                onDragDone: _onDragDone,
                                child: rawEditor,
                              );
                            },
                            embedBuilders: kIsWeb
                                ? FlutterQuillEmbeds.editorWebBuilders(
                                    imageEmbedConfigurations:
                                        QuillEditorImageEmbedConfigurations(
                                      imageErrorWidgetBuilder:
                                          (context, error, stackTrace) {
                                        // Display an error icon in place of the image
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              duration: const Duration(
                                                  milliseconds: 3000),
                                              content: Text(
                                                'Error loading image: ${error.toString()}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            ),
                                          );
                                        });
                                        return const Icon(
                                          Icons.error,
                                          color: Colors.red,
                                          size: 50.0,
                                        );
                                      },
                                    ),
                                    videoEmbedConfigurations: null,
                                  )
                                : FlutterQuillEmbeds.editorBuilders(
                                    videoEmbedConfigurations: null,
                                  ),
                            padding: const EdgeInsets.all(8.0),
                            disableClipboard: false,
                            maxContentWidth: parentWidth,
                            minHeight: 200,
                            maxHeight: 400,
                            sharedConfigurations:
                                const quill.QuillSharedConfigurations(
                              locale: Locale('en_US'),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
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
                      TextFormField(
                        key: const ValueKey('jsonData'),
                        controller: textEditingController,
                        readOnly: true,
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
                            final delta =
                                _contentGeneratorController.document.toDelta();
                            final json = jsonDecode(jsonEncode(delta.toJson()));
                            setState(() {
                              // Assuming json is your input JSON data for the document
                              final document = quill.Document.fromJson(json);

                              // Convert the document back to JSON for easy logging
                              documentJson =
                                  jsonEncode(document.toDelta().toJson());
                              textEditingController.text = documentJson;
                              developer.log('String Delta: $documentJson');
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
