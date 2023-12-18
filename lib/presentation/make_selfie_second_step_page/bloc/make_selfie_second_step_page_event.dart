import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

sealed class MakeSelfieSecondStepPageEvent {}

class OnTapBackEvent extends MakeSelfieSecondStepPageEvent {
  final BuildContext context;

  OnTapBackEvent({required this.context});
}

class OnTapMakePhotoEvent extends MakeSelfieSecondStepPageEvent {
  final XFile photo;

  OnTapMakePhotoEvent({required this.photo});
}

class OnTapMakePhotoAgainEvent extends MakeSelfieSecondStepPageEvent {}

class OnTapSendPhotoEvent extends MakeSelfieSecondStepPageEvent {
  OnTapSendPhotoEvent();
}

class OnRestartImageStream extends MakeSelfieSecondStepPageEvent {}

class OnCameraErrorEvent extends MakeSelfieSecondStepPageEvent {}

class CameraImageEvent extends MakeSelfieSecondStepPageEvent {
  final CameraImage inputImage;
  final FaceDetector faceDetector;
  final CameraController cameraController;
  final int sensorOrientation;

  CameraImageEvent(
      {required this.inputImage,
      required this.faceDetector,
      required this.cameraController,
      required this.sensorOrientation});
}
