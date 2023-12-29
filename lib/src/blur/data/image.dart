import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;

class ImageHelper {
  const ImageHelper();

  static final black = img.ColorUint8.rgb(0, 0, 0);
  static final white = img.ColorUint8.rgb(255, 255, 255);

  static final detector = FaceDetector(
    options: FaceDetectorOptions(
      enableTracking: true,
    ),
  );
}

img.Image getMaskFromFaces(
    int height, int width, List<Face> faces, Set<int> unBlur) {
  img.Image mask = img.Image(
      width: width,
      height: height,
      numChannels: 1,
      backgroundColor: ImageHelper.white);
  for (final face in faces) {
    if (!unBlur.contains(face.trackingId)) {
      img.drawRect(mask,
          x1: face.boundingBox.bottomRight.dx.round(),
          y1: face.boundingBox.bottomRight.dy.round(),
          x2: face.boundingBox.topLeft.dx.round(),
          y2: face.boundingBox.topLeft.dy.round(),
          color: ImageHelper.black,
          radius: 2);
    }
  }
  return mask;
}

img.Image blurImage(img.Image src, img.Image mask) {
  img.Image temp = img.Image.from(src);
  return img.gaussianBlur(temp, radius: 20, mask: mask);
}

Future<ui.Image> blurImagefromFile(File image, Set<int> unBlur) async {
  final ui.Image decodedImage =
      await decodeImageFromList(image.readAsBytesSync());
  final img.Image rawImage = await convertFlutterUiToImage(decodedImage);
  final faces =
      await ImageHelper.detector.processImage(InputImage.fromFile(image));
  log('${faces.length}');
  final blurredImage = blurImage(rawImage,
      getMaskFromFaces(decodedImage.height, decodedImage.width, faces, unBlur));

  return convertImageToFlutterUi(blurredImage);
}

// The following code is provided by Dart Image Package:     /////////////
//////////////////////////////////////////////////////////////////////////
Future<ui.Image> convertImageToFlutterUi(img.Image image) async {
  if (image.format != img.Format.uint8 || image.numChannels != 4) {
    final cmd = img.Command()
      ..image(image)
      ..convert(format: img.Format.uint8, numChannels: 4);
    final rgba8 = await cmd.getImageThread();
    if (rgba8 != null) {
      image = rgba8;
    }
  }

  ui.ImmutableBuffer buffer =
      await ui.ImmutableBuffer.fromUint8List(image.toUint8List());

  ui.ImageDescriptor id = ui.ImageDescriptor.raw(buffer,
      height: image.height,
      width: image.width,
      pixelFormat: ui.PixelFormat.rgba8888);

  ui.Codec codec = await id.instantiateCodec(
      targetHeight: image.height, targetWidth: image.width);

  ui.FrameInfo fi = await codec.getNextFrame();
  ui.Image uiImage = fi.image;

  return uiImage;
}

Future<img.Image> convertFlutterUiToImage(ui.Image uiImage) async {
  final uiBytes = await uiImage.toByteData();

  final image = img.Image.fromBytes(
      width: uiImage.width,
      height: uiImage.height,
      bytes: uiBytes!.buffer,
      numChannels: 4);

  return image;
}
  //////////////////////////////////////////////////////////////////////////
