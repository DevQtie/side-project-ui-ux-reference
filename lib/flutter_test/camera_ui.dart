import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart' show kIsWeb;

class CameraSetting extends StatelessWidget {
  const CameraSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Test'),
      ),
      body: SizedBox(
        child: Center(
          child: Wrap(
            spacing: 8.0,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const SelfieCamera()),
                    );
                  },
                  child: Text('Take a selfie')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const IDCamera()),
                    );
                  },
                  child: Text('Capture ID')),
            ],
          ),
        ),
      ),
    );
  }
}

class SelfieCamera extends StatefulWidget {
  const SelfieCamera({super.key});

  @override
  State<SelfieCamera> createState() => _SelfieCameraState();
}

class _SelfieCameraState extends State<SelfieCamera> {
  CameraController? _cameraController;

  List<CameraDescription> _cameras = [];

  bool _isCameraInitialized = false;
  bool _isCameraActive = false; // State variable to track icon state
  File? imgFile;
  bool _isCaptured = false;
  bool _isContinued = false;
  bool _hasExecuted = false;

  CountdownTimerController _countDownController =
      CountdownTimerController(endTime: 0, onEnd: null);
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 6;

  Future<void> _initializeCamera() async {
    try {
      // Get the list of available cameras
      _cameras = await availableCameras();

      // Find the front camera
      final frontCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );

      // Initialize the camera controller for the back camera
      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      // Add a listener to update state when the camera is initialized
      await _cameraController!.initialize();
      await _cameraController!
          .lockCaptureOrientation(DeviceOrientation.portraitUp);
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  Future<bool> _alreadyHasAccessToExternal() async {
    // Check for access premission
    return await Gal.hasAccess();
  }

  Future<bool> _requestAccessToExternal() async {
    if (await _alreadyHasAccessToExternal()) {
      // Request access premission
      await Gal.requestAccess();
    }
    return false;
  }

  Future<void> _captureImage(BuildContext context) async {
    if (!_hasExecuted) {
      // setState(() {
      //   // _hasExecuted = true; // allow continuous regression testing
      //   _isCameraActive = !_isCameraActive; // Toggle state on click
      // });

      // Future.delayed(const Duration(milliseconds: 100), () {
      //   setState(() {
      //     _isCameraActive = !_isCameraActive; // Toggle state on click
      //   });
      // });
      try {
        if (_cameraController != null &&
            _cameraController!.value.isInitialized) {
          // Capture the image as an XFile (not saving it to disk yet).
          final XFile image = await _cameraController!.takePicture();
          // // debugPrint('Picture captured: ${image.path}');

          // // Save to the gallery manually
          final String savedPath = await _saveImageToGallery(image.path);

          if (savedPath == '') {
            return;
          }
          // debugPrint('Image saved to gallery: $savedPath');

          // // Get the exact file size by accessing the file
          File tempImageFile = File(savedPath);
          int fileSizeInBytes =
              await tempImageFile.length(); // Exact file size in bytes.

          // // Convert to kilobytes (KB) and megabytes (MB).
          double fileSizeInKB = fileSizeInBytes / 1024;
          double fileSizeInMB = fileSizeInKB / 1024;

          debugPrint('Image size: $fileSizeInKB KB');
          debugPrint('Image size: $fileSizeInMB MB');

          // dynamic response = await _apiHelper.uploadFrontID(
          //     '/api/postget/f_id_upload', tempImageFile, fileSizeInKB);

          setState(() {
            imgFile =
                tempImageFile; // findings, in order to get the image data, it must retrieve the actual file
            return;
          });

          // Save Image with try-catch
          try {
            if (context.mounted) {
              await Gal.putImage(image.path,
                  album: '0/DCIM'); //to test; saved in gallery
              // debugPrint('Image saved to gallery: 0/DCIM');

              if (_isContinued) {
                Future.delayed(const Duration(milliseconds: 1000), () {
                  setState(() {
                    _isCaptured = false;
                  });
                  if (context.mounted) {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  }
                });
              }
            }
          } on GalException catch (e) {
            debugPrint(e.type.message);
          }
        }
      } catch (e) {
        debugPrint('Error capturing image: $e');
      }
    }
  }

  Future<String> _saveImageToGallery(String imagePath) async {
    try {
      // Get the directory where you want to save the image
      final Directory? directory = await getExternalStorageDirectory();
      if (directory != null) {
        // Create a "Pictures" directory if it doesn't exist
        final String newDirectoryPath = path.join(directory.path, 'Pictures');
        await Directory(newDirectoryPath).create(recursive: true);

        // Define the new file path
        final String newPath =
            path.join(newDirectoryPath, path.basename(imagePath));

        // Copy the file to the new path
        final File newImage = await File(imagePath).copy(newPath);

        return newImage.path; // Return the new path if successful
      }
    } catch (e) {
      debugPrint('Error saving image to gallery: $e');
    }

    return '';
  }

  void onEnd() {
    _countDownController.disposeTimer();
    debugPrint('onEnd');
    setState(() {
      _isContinued = true;
      _captureImage(context);
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _alreadyHasAccessToExternal();
    _requestAccessToExternal();
    _countDownController =
        CountdownTimerController(endTime: endTime, onEnd: onEnd);
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _countDownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Icon(CupertinoIcons.person),
      ),
      body: _isCameraInitialized
          ? SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Center(
                child: Stack(
                  children: [
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..scale(-1.0, 1.0, 1.0), // Flip horizontally,
                      child: Transform.scale(
                        scale: 0.5 /
                            (_cameraController!.value.aspectRatio *
                                MediaQuery.of(context).size.aspectRatio),
                        // scaleX: 2.5 /
                        //     (_cameraController!.value.aspectRatio /
                        //         MediaQuery.of(context).size.aspectRatio),
                        // scaleY: 2.05 /
                        //     (_cameraController!.value.aspectRatio /
                        //         MediaQuery.of(context).size.aspectRatio),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipOval(
                              child: SizedBox(
                                height: 600,
                                width: 600,
                                child: CameraPreview(_cameraController!),
                              ),
                            ),
                            ClipOval(
                              child: SizedBox(
                                height: 600,
                                width: 600,
                                child: CountdownTimer(
                                    controller: _countDownController,
                                    onEnd: onEnd,
                                    endTime: endTime,
                                    widgetBuilder: (_, time) {
                                      if (time == null) {
                                        return SizedBox();
                                      }
                                      return CircularProgressIndicator(
                                        strokeWidth: 50,
                                        value: double.parse(
                                            '${((5 - time.sec!) / 5)}'),
                                      );
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: CountdownTimer(
                          controller: _countDownController,
                          onEnd: onEnd,
                          endTime: endTime,
                          widgetBuilder: (_, time) {
                            if (time == null) {
                              // WidgetsBinding.instance.addPostFrameCallback((_) {
                              //   if (context.mounted) {
                              //     if (Navigator.of(context).canPop()) {
                              //       Navigator.of(context).pop();
                              //     }
                              //   }
                              // });
                              return SizedBox();
                              // return Center(
                              //   child: TextButton(
                              //       onPressed: () {
                              //         if (Navigator.of(context).canPop()) {
                              //           Navigator.of(context).pop();
                              //         }
                              //       },
                              //       child: Text(
                              //         'Go Back',
                              //         style: Theme.of(context)
                              //             .textTheme
                              //             .headlineMedium
                              //             ?.copyWith(decoration: TextDecoration.underline),
                              //       )),
                              // );
                            }
                            return Center(
                                child: Text(
                              '${time.sec!}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.copyWith(fontSize: 120),
                            ));
                          }),
                    ),
                  ],
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class MyClip extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, 100, 100);
  }

  @override
  bool shouldReclip(oldClipper) {
    return false;
  }
}

class IDCamera extends StatefulWidget {
  const IDCamera({super.key});

  @override
  State<IDCamera> createState() => _IDCameraState();
}

class _IDCameraState extends State<IDCamera> {
  CameraController? _cameraController;

  List<CameraDescription> _cameras = [];

  bool _isCameraInitialized = false;
  bool _isCameraActive = false; // State variable to track icon state
  File? imgFile;
  bool _isCaptured = false;
  bool _isContinued = false;
  bool _hasExecuted = false;

  CountdownTimerController _countDownController =
      CountdownTimerController(endTime: 0, onEnd: null);
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 6;

  Future<void> _initializeCamera() async {
    try {
      // Get the list of available cameras
      _cameras = await availableCameras();

      // Find the front camera
      final frontCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
      );

      // Initialize the camera controller for the back camera
      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      // Add a listener to update state when the camera is initialized
      await _cameraController!.initialize();
      await _cameraController!
          .lockCaptureOrientation(DeviceOrientation.portraitUp);
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  Future<bool> _alreadyHasAccessToExternal() async {
    // Check for access premission
    return await Gal.hasAccess();
  }

  Future<bool> _requestAccessToExternal() async {
    if (await _alreadyHasAccessToExternal()) {
      // Request access premission
      await Gal.requestAccess();
    }
    return false;
  }

  Future<void> _captureImage(BuildContext context) async {
    if (!_hasExecuted) {
      // setState(() {
      //   // _hasExecuted = true; // allow continuous regression testing
      //   _isCameraActive = !_isCameraActive; // Toggle state on click
      // });

      // Future.delayed(const Duration(milliseconds: 100), () {
      //   setState(() {
      //     _isCameraActive = !_isCameraActive; // Toggle state on click
      //   });
      // });
      try {
        if (_cameraController != null &&
            _cameraController!.value.isInitialized) {
          // Capture the image as an XFile (not saving it to disk yet).
          final XFile image = await _cameraController!.takePicture();
          // // debugPrint('Picture captured: ${image.path}');

          // // Save to the gallery manually
          final String savedPath = await _saveImageToGallery(image.path);

          if (savedPath == '') {
            return;
          }
          // debugPrint('Image saved to gallery: $savedPath');

          // // Get the exact file size by accessing the file
          File tempImageFile = File(savedPath);
          int fileSizeInBytes =
              await tempImageFile.length(); // Exact file size in bytes.

          // // Convert to kilobytes (KB) and megabytes (MB).
          double fileSizeInKB = fileSizeInBytes / 1024;
          double fileSizeInMB = fileSizeInKB / 1024;

          debugPrint('Image size: $fileSizeInKB KB');
          debugPrint('Image size: $fileSizeInMB MB');

          // dynamic response = await _apiHelper.uploadFrontID(
          //     '/api/postget/f_id_upload', tempImageFile, fileSizeInKB);

          setState(() {
            imgFile =
                tempImageFile; // findings, in order to get the image data, it must retrieve the actual file
            return;
          });

          // Save Image with try-catch
          try {
            if (context.mounted) {
              await Gal.putImage(image.path,
                  album: '0/DCIM'); //to test; saved in gallery
              // debugPrint('Image saved to gallery: 0/DCIM');

              if (_isContinued) {
                Future.delayed(const Duration(milliseconds: 1000), () {
                  setState(() {
                    _isCaptured = false;
                  });
                  if (context.mounted) {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  }
                });
              }
            }
          } on GalException catch (e) {
            debugPrint(e.type.message);
          }
        }
      } catch (e) {
        debugPrint('Error capturing image: $e');
      }
    }
  }

  Future<String> _saveImageToGallery(String imagePath) async {
    try {
      // Get the directory where you want to save the image
      final Directory? directory = await getExternalStorageDirectory();
      if (directory != null) {
        // Create a "Pictures" directory if it doesn't exist
        final String newDirectoryPath = path.join(directory.path, 'Pictures');
        await Directory(newDirectoryPath).create(recursive: true);

        // Define the new file path
        final String newPath =
            path.join(newDirectoryPath, path.basename(imagePath));

        // Copy the file to the new path
        final File newImage = await File(imagePath).copy(newPath);

        return newImage.path; // Return the new path if successful
      }
    } catch (e) {
      debugPrint('Error saving image to gallery: $e');
    }

    return '';
  }

  void onEnd() {
    _countDownController.disposeTimer();
    debugPrint('onEnd');
    setState(() {
      _isContinued = true;
      _captureImage(context);
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _alreadyHasAccessToExternal();
    _requestAccessToExternal();
    _countDownController =
        CountdownTimerController(endTime: endTime, onEnd: onEnd);
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _countDownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Icon(CupertinoIcons.person),
      ),
      body: _isCameraInitialized
          ? SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Center(
                child: Stack(
                  children: [
                    ClipRect(
                        child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.45,
                            width: MediaQuery.of(context).size.width * 0.85,
                            // color: Colors.transparent,
                            child: CameraPreview(_cameraController!))),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: CountdownTimer(
                          controller: _countDownController,
                          onEnd: onEnd,
                          endTime: endTime,
                          widgetBuilder: (_, time) {
                            if (time == null) {
                              // WidgetsBinding.instance.addPostFrameCallback((_) {
                              //   if (context.mounted) {
                              //     if (Navigator.of(context).canPop()) {
                              //       Navigator.of(context).pop();
                              //     }
                              //   }
                              // });
                              return SizedBox();
                              // return Center(
                              //   child: TextButton(
                              //       onPressed: () {
                              //         if (Navigator.of(context).canPop()) {
                              //           Navigator.of(context).pop();
                              //         }
                              //       },
                              //       child: Text(
                              //         'Go Back',
                              //         style: Theme.of(context)
                              //             .textTheme
                              //             .headlineMedium
                              //             ?.copyWith(decoration: TextDecoration.underline),
                              //       )),
                              // );
                            }
                            return Center(
                                child: Text(
                              '${time.sec}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.copyWith(fontSize: 120),
                            ));
                          }),
                    ),
                  ],
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
