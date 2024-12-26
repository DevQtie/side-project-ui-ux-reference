// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

// class FaceDetectionPage extends StatefulWidget {
//   const FaceDetectionPage({super.key});

//   @override
//   FaceDetectionPageState createState() => FaceDetectionPageState();
// }

// class FaceDetectionPageState extends State<FaceDetectionPage> {
//   late CameraController _cameraController;
//   late Future<void> _initializeControllerFuture;
//   final FaceDetector _faceDetector = FaceDetector(
//     options: FaceDetectorOptions(
//       enableTracking: true,
//       enableClassification: true,
//     ),
//   );

//   bool _isFaceDetected = false;
//   bool _isLeftEyeOpen = false;
//   bool _isRightEyeOpen = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }

//   @override
//   void dispose() {
//     _cameraController.dispose();
//     _faceDetector.close();
//     super.dispose();
//   }

//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//     final camera = cameras.first;

//     _cameraController = CameraController(
//       camera,
//       ResolutionPreset.medium,
//       enableAudio: false,
//     );
//     _initializeControllerFuture = _cameraController.initialize();

//     _cameraController.startImageStream(_processCameraFrame);
//   }

//   Future<void> _processCameraFrame(CameraImage image) async {
//     final inputImage = _convertCameraImage(image);
//     final faces = await _faceDetector.processImage(inputImage);

//     if (faces.isNotEmpty) {
//       final face = faces.first;
//       setState(() {
//         _isFaceDetected = true;
//         _isLeftEyeOpen = face.leftEyeOpenProbability != null &&
//             face.leftEyeOpenProbability! > 0.5;
//         _isRightEyeOpen = face.rightEyeOpenProbability != null &&
//             face.rightEyeOpenProbability! > 0.5;
//       });
//     } else {
//       setState(() {
//         _isFaceDetected = false;
//         _isLeftEyeOpen = false;
//         _isRightEyeOpen = false;
//       });
//     }
//   }

//   InputImage _convertCameraImage(CameraImage image) {
//     final WriteBuffer allBytes = WriteBuffer();
//     for (Plane plane in image.planes) {
//       allBytes.putUint8List(plane.bytes);
//     }
//     final bytes = allBytes.done().buffer.asUint8List();

//     final Size imageSize =
//         Size(image.width.toDouble(), image.height.toDouble());

//     final camera = _cameraController.description;
//     final imageRotation =
//         InputImageRotationValue.fromRawValue(camera.sensorOrientation) ??
//             InputImageRotation.rotation0deg;

//     final inputImageFormat =
//         InputImageFormatValue.fromRawValue(image.format.raw) ??
//             InputImageFormat.nv21;

//     final planeData = image.planes.map((Plane plane) {
//       return InputImagePlaneMetadata(
//         bytesPerRow: plane.bytesPerRow,
//         height: plane.height,
//         width: plane.width,
//       );
//     }).toList();

//     final inputImageData = InputImageData(
//       size: imageSize,
//       imageRotation: imageRotation,
//       inputImageFormat: inputImageFormat,
//       planeData: planeData,
//     );

//     return InputImage.fromBytes(
//         bytes: bytes, inputImageData: inputImageData, metadata: null);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Face Detection'),
//       ),
//       body: FutureBuilder<void>(
//         future: _initializeControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return Stack(
//               children: [
//                 CameraPreview(_cameraController),
//                 if (_isFaceDetected)
//                   Positioned(
//                     top: 20,
//                     left: 20,
//                     child: Text(
//                       'Face Detected\nLeft Eye: ${_isLeftEyeOpen ? 'Open' : 'Closed'}\nRight Eye: ${_isRightEyeOpen ? 'Open' : 'Closed'}',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         backgroundColor: Colors.black54,
//                       ),
//                     ),
//                   ),
//               ],
//             );
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
// }
