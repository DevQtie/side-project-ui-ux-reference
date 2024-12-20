import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

class CustomizedFlutterQuill extends StatefulWidget {
  const CustomizedFlutterQuill({super.key});

  @override
  State<CustomizedFlutterQuill> createState() => _CustomizedFlutterQuillState();
}

class _CustomizedFlutterQuillState extends State<CustomizedFlutterQuill> {
  final _fQuillController1 = quill.QuillController.basic();
  final _fQuillController2 = quill.QuillController.basic();

  Icon _dynamicIcon = Icon(Icons.lock);
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _fQuillController1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Quill Test'),
      ),
      body: Center(
        child: Column(
          children: [
            quill.QuillToolbar.simple(
              controller: _fQuillController1,
              configurations: quill.QuillSimpleToolbarConfigurations(
                customButtons: [
                  quill.QuillToolbarCustomButtonOptions(
                    icon: _dynamicIcon,
                    onPressed: () {
                      setState(() {
                        _isSelected = !_isSelected; // Toggle selection
                        _dynamicIcon = _isSelected
                            ? Icon(
                                Icons.lock_open,
                                color: Colors.blueAccent,
                              )
                            : Icon(Icons.lock); // Update icon
                        _fQuillController1.formatText(
                          _fQuillController1.selection.baseOffset,
                          _fQuillController1.selection.extentOffset,
                          quill.Attribute.bold,
                        );
                      });
                    },
                  ),
                ],
                showSuperscript: false,
                showClearFormat: false,
                showHeaderStyle: false,
                showListNumbers: false,
                showListBullets: false,
                showListCheck: false,
                showRedo: false,
                showUndo: false,
                showFontFamily: false,
                showBoldButton: false,
                showFontSize: false,
                showItalicButton: false,
                showUnderLineButton: false,
                showDividers: true,
                showAlignmentButtons: false,
                showInlineCode: false,
                showCodeBlock: false,
                showColorButton: false,
                showBackgroundColorButton: false,
                showSearchButton: false,
                showQuote: false,
                showSubscript: false,
                showStrikeThrough: false,
                sectionDividerColor: const Color.fromARGB(170, 255, 193, 7),
                sectionDividerSpace: 5.0,
                toolbarSectionSpacing: 5.0,
              ),
            ),
            quill.QuillEditor.basic(
              controller: _fQuillController1,
              configurations: quill.QuillEditorConfigurations(
                padding: const EdgeInsets.all(8.0),
                disableClipboard: false,
                minHeight: 200,
                maxHeight: 400,
                sharedConfigurations: const quill.QuillSharedConfigurations(
                  locale: Locale('en_US'),
                ),
              ), //make this as ready-only if only showing a created flutter_quill text
            ),
            quill.QuillToolbar.simple(
              controller: _fQuillController2,
              configurations: quill.QuillSimpleToolbarConfigurations(
                customButtons: [
                  quill.QuillToolbarCustomButtonOptions(
                    icon: _dynamicIcon,
                    onPressed: () {
                      setState(() {
                        _isSelected = !_isSelected; // Toggle selection
                        _dynamicIcon = _isSelected
                            ? Icon(
                                Icons.lock_open,
                                color: Colors.blueAccent,
                              )
                            : Icon(Icons.lock); // Update icon
                        _fQuillController2.formatText(
                          _fQuillController2.selection.baseOffset,
                          _fQuillController2.selection.extentOffset,
                          quill.Attribute.bold,
                        );
                      });
                    },
                  ),
                ],
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
                sectionDividerColor: const Color.fromARGB(170, 255, 193, 7),
                sectionDividerSpace: 5.0,
                toolbarSectionSpacing: 5.0,
              ),
            ),
            quill.QuillEditor.basic(
              controller: _fQuillController2,
              configurations: quill.QuillEditorConfigurations(
                padding: const EdgeInsets.all(8.0),
                disableClipboard: false,
                minHeight: 200,
                maxHeight: 400,
                sharedConfigurations: const quill.QuillSharedConfigurations(
                  locale: Locale('en_US'),
                ),
              ), //make this as ready-only if only showing a created flutter_quill text
            ),
          ],
        ),
      ),
    );
  }
}
