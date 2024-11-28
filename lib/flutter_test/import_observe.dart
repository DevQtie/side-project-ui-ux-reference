import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImportObserve extends StatefulWidget {
  const ImportObserve({super.key});

  @override
  State<ImportObserve> createState() => _ImportObserveState();
}

class _ImportObserveState extends State<ImportObserve> {
  String? _path;
  ImagePicker? _imagePicker;

  Future _getImage(ImageSource source) async {
    setState(() {
      _path = null;
    });
    final pickedFile = await _imagePicker?.pickImage(source: source);
    if (pickedFile != null) {
      _processFile(pickedFile.path);
    }
  }

  Future _processFile(String path) async {
    setState(() {
      // _image = File(path);
    });
    _path = path;
    // final inputImage = InputImage.fromFilePath(path);
    // widget.onImage(inputImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Test Import'),
        ),
        body: Center(
          child: ElevatedButton(
              onPressed: () => _getImage(ImageSource.gallery),
              child: Text('web test')),
        ));
  }
}
