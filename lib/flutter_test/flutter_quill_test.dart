import 'dart:convert';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/main.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:developer' as developer;
import 'dart:html' as html;

class FlutterQuillTest extends StatefulWidget {
  const FlutterQuillTest({super.key});

  @override
  State<FlutterQuillTest> createState() => _FlutterQuillTestState();
}

class _FlutterQuillTestState extends State<FlutterQuillTest> {
  final _wYSIWYGTextEditorControllerComposed = quill.QuillController.basic();
  final _wYSIWYGTextEditorControllerExtract = quill.QuillController.basic();

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
    // '.gif', //depending on them
    // '.webp',
    // '.tif',
    // '.heic'
  ];

  // Define max file size (e.g., 5 MB)
  static const int maxFileSizeInBytes = 3 * 1024 * 1024;

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
      _wYSIWYGTextEditorControllerComposed.insertImageBlock(
        imageSource: file.path,
      );
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Image is inserted.'),
        ),
      );
    };
  }

  Future<bool> _isValidImage(String imageUrl) async {
    // Fetch the image to get its size
    try {
      final response = await html.HttpRequest.request(
        imageUrl,
        responseType: 'blob', // Use 'blob' to get binary data
      );

      // Check if the size exceeds the maximum limit
      final sizeInBytes = response.response.size; // size is in bytes
      return sizeInBytes <= maxFileSizeInBytes; // Check size constraint
    } catch (e) {
      // Handle any errors that occur during the request
      developer.log('Error fetching image: $e');
      return false; // Invalid image
    }
  }

  @override
  void initState() {
    super.initState();
    quillFocusNode.canRequestFocus = false;
  }

  @override
  void dispose() {
    _wYSIWYGTextEditorControllerComposed.dispose();
    _wYSIWYGTextEditorControllerExtract.dispose();
    super.dispose();
  }

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
                                quill.QuillSimpleToolbarConfigurations(
                              dialogTheme: quill.QuillDialogTheme(
                                dialogBackgroundColor: isDarkMode
                                    ? Colors.grey.shade900
                                    : Colors.grey.shade100,
                              ),
                              embedButtons: FlutterQuillEmbeds.toolbarButtons(
                                imageButtonOptions: null,
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
                                      // imageProviderBuilder: (context, imageUrl) {

                                      // },
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
                          ), //make this as ready-only if only showing a created flutter_quill text
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      quill.QuillEditor.basic(
                        focusNode: quillFocusNode,
                        controller: _wYSIWYGTextEditorControllerExtract,
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
