// import 'dart:typed_data';
// import 'dart:ui';

// import 'package:camera/camera.dart';
// import 'package:faceblur/src/blur/data/image.dart';
// import 'package:faceblur/src/blur/domain/custom_paint_mask.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

// import 'package:faceblur/src/blur/domain/blur_painter.dart';

// class FacePreviewPage extends StatefulWidget {
//   const FacePreviewPage(
//       {super.key,
//       required this.image,
//       required this.height,
//       required this.width});

//   final Uint8List image;
//   final double height;
//   final double width;

//   @override
//   State<FacePreviewPage> createState() => _FacePreviewPageState();
// }

// class _FacePreviewPageState extends State<FacePreviewPage> {
//   final FaceDetector _faceDetector = FaceDetector(
//     options: FaceDetectorOptions(
//       enableTracking: true,
//     ),
//   );
//   bool _canProcess = true;
//   bool _isBusy = false;
//   FaceMaskPainter? _customPaint;
//   final Set<int?> _blurredFaces = {};
//   String? _text;
//   final _cameraLensDirection = CameraLensDirection.back;

//   @override
//   void dispose() {
//     _canProcess = false;
//     _faceDetector.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Image image = Image.memory(widget.image);
//     return FittedBox(
//       child: SizedBox(
//         height: widget.height,
//         width: widget.width,
//         child: Stack(
//           children: [
//             image,
//             if (_customPaint != null)
//               CustomPaintMask(
//                 painter: _customPaint!,
//                 child: ImageFiltered(
//                   imageFilter: ImageFilter.blur(),
//                   child: image,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _processImage(InputImage inputImage) async {
//     if (!_canProcess) return;
//     if (_isBusy) return;
//     _isBusy = true;
//     setState(() {
//       _text = '';
//     });
//     final faces = await _faceDetector.processImage(inputImage);
//     if (inputImage.metadata?.size != null &&
//         inputImage.metadata?.rotation != null) {
//       final painter = FaceMaskPainter(
//         faces,
//         _blurredFaces,
//         inputImage.metadata!.size,
//         inputImage.metadata!.rotation,
//         _cameraLensDirection,
//       );
//       _customPaint = painter;
//     } else {
//       String text = 'Faces found: ${faces.length}\n\n';
//       for (final face in faces) {
//         text += 'face: ${face.boundingBox}\n\n';
//       }
//       _text = text;
//       _customPaint = null;
//     }
//     _isBusy = false;
//     if (mounted) {
//       setState(() {});
//     }
//   }
// }
