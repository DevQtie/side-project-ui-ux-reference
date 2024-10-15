import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/generated/l10n.dart';
import 'package:flutter_observer/methods/dialog_uncommon.dart';
import 'package:gal/gal.dart';
import 'dart:developer' as developer;

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageMemory extends StatefulWidget {
  const ImageMemory({super.key});

  @override
  State<ImageMemory> createState() => _ImageMemoryState();
}

class _ImageMemoryState extends State<ImageMemory> with WidgetsBindingObserver {
  String imageSample =
      'iVBORw0KGgoAAAANSUhEUgAAAQAAAAEACAIAAADTED8xAAADMElEQVR4nOzVwQnAIBQFQYXff81RUkQCOyDj1YOPnbXWPmeTRef+/3O/OyBjzh3CD95BfqICMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMO0TAAD//2Anhf4QtqobAAAAAElFTkSuQmCC';

  final _dialogUncommon = DialogUncommon();
  final String filePathORIG = '1728492977650-504960504-ORIG.jpg';
  final String filePathLSS2CCL9 = '1728492977650-504960504-LSS2C_CL9.jpg';
  final String filePathLSS2CCL9Q1 = '1728492977650-504960504-LSS2C_CL9-Q1.jpg';

  String globalBased64Image = '';
  String globalFilePath = '';

  Future<XFile?> base64ToXFile(String base64String) async {
    try {
      // Decode the base64 string into bytes
      Uint8List imageBytes = base64Decode(base64String);

      // Get the temporary directory to store the file
      Directory? tempDir = await getExternalStorageDirectory();
      if (tempDir != null) {
        // Create a "Pictures" directory if it doesn't exist
        final String newDirectoryPath = path.join(tempDir.path, 'Pictures');
        await Directory(newDirectoryPath).create(recursive: true);

        // Define the new file path
        final String newPath =
            path.join(newDirectoryPath, path.basename(globalFilePath));

        // Write the image bytes to a file
        File imageFile = File(newPath);
        await imageFile.writeAsBytes(imageBytes);

        // Convert the File to XFile
        XFile xfile = XFile(newPath);

        return xfile;
      }
    } catch (e) {
      debugPrint('Error converting base64 to XFile: $e');
      rethrow;
    }
    return null;
  }

  Future<void> _saveImage(String image) async {
    XFile? saveImage = await base64ToXFile(image);
    if (saveImage != null) {
      // Define the album path where the image should be saved
      const String albumPath =
          'storage/emulated/0/pictures/0/dcim'; //folder for the gallery

      // Directory appDirectory = await getApplicationDocumentsDirectory();
      // Define the full path where the image will be saved
      final String targetFilePath =
          path.join(albumPath, path.basename(saveImage.path));

      // developer.log(saveImage.path);

      // Check if the file already exists in the target album (DCIM)
      // if (Directory(targetFilePath).existsSync()) { // to check if the directory exists first,
      ////in order for the more accuracy of locating the file
      if (File(targetFilePath).existsSync()) {
        if (mounted) {
          _dialogUncommon.showAutoDismissDialog(
              context,
              'The image is already existing!',
              CupertinoIcons.exclamationmark_circle_fill,
              Colors.redAccent);
        }
        return;
      }
      //  else {
      //   if (mounted) {
      //     _dialogUncommon.showAutoDismissDialog(context, 'Keep it up!',
      //         CupertinoIcons.exclamationmark_circle_fill, Colors.redAccent);
      //   }
      //   return;
      // } // for testing purposes

      await Gal.putImage(saveImage.path,
          album: '0/DCIM'); //to test; saved in gallery
      if (mounted) {
        _dialogUncommon.showAutoDismissDialog(
            context,
            'Downloaded Successfully!\nImage is saved to gallery: Pictures/0/DCIM',
            CupertinoIcons.check_mark_circled,
            Colors.greenAccent);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    globalFilePath = filePathORIG;
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        globalBased64Image = S.of(context).imageSample_ORIGINAL;
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Base64 Tester',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.normal),
        ),
        forceMaterialTransparency: true,
        actions: [
          globalFilePath == ''
              ? const CircularProgressIndicator()
              : Tooltip(
                  message: 'Download\n$globalFilePath',
                  textAlign: TextAlign.center,
                  child: IconButton(
                      onPressed: () {
                        _saveImage(globalBased64Image);
                      },
                      icon: const Icon(CupertinoIcons.cloud_download)),
                )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
            color: Colors.transparent), //colorScheme.surfaceContainerHighest),
        child: Stack(
          children: [
            Center(
              child: globalBased64Image == ''
                  ? const CircularProgressIndicator()
                  : Image.memory(base64Decode(globalBased64Image)),
            ),
          ],
        ),
      ),
    );
  }
}
