import 'dart:async';
import 'dart:io';
import 'package:face_blink_datection/presentation/make_selfie_second_step_page/bloc/make_selfie_second_step_page_event.dart';
import 'package:face_blink_datection/presentation/make_selfie_second_step_page/bloc/make_selfie_second_step_page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

class MakeSelfieSecondStepPageBloc extends Bloc<MakeSelfieSecondStepPageEvent, MakeSelfieSecondStepPageState> {
  MakeSelfieSecondStepPageBloc() : super(MakeSelfieSecondStepPageState.initial()) {
    on<OnTapBackEvent>(_onTapBack);
    on<OnTapMakePhotoEvent>(_onTapMakePhotoEvent);
    on<CameraImageEvent>(_cameraImageEvent, transformer: droppable());
    on<OnCameraErrorEvent>(_onCameraErrorEvent);
    on<OnTapMakePhotoAgainEvent>(_onTapMakePhotoAgainEvent);
    on<OnTapSendPhotoEvent>(_onTapSendPhotoEvent);
    on<OnRestartImageStream>(_onRestartImageStream);
  }

  void _onTapBack(OnTapBackEvent event, Emitter<MakeSelfieSecondStepPageState> emit) => Navigator.pop(event.context);

  void _onCameraErrorEvent(OnCameraErrorEvent event, Emitter<MakeSelfieSecondStepPageState> emit) =>
      emit(state.setError(true));

  void _onTapMakePhotoEvent(OnTapMakePhotoEvent event, Emitter<MakeSelfieSecondStepPageState> emit) {
    emit(state.setPhoto(event.photo));
  }

  void _onTapSendPhotoEvent(OnTapSendPhotoEvent event, Emitter<MakeSelfieSecondStepPageState> emit) {
    // todo call for use case for sending photos to back
  }

  void _onTapMakePhotoAgainEvent(OnTapMakePhotoAgainEvent event, Emitter<MakeSelfieSecondStepPageState> emit) {
    emit(state.setPhoto(null).setUserBlinked(false).setUserFaceInOval(false).setError(true));
  }

  void _onRestartImageStream(OnRestartImageStream event, Emitter<MakeSelfieSecondStepPageState> emit) =>
      emit(state.setRestartImageStream(true));

  Future<void> _cameraImageEvent(CameraImageEvent event, Emitter<MakeSelfieSecondStepPageState> emit) async {
    late dynamic newState;
    final orientations = {
      DeviceOrientation.portraitUp: 0,
      DeviceOrientation.landscapeLeft: 90,
      DeviceOrientation.portraitDown: 180,
      DeviceOrientation.landscapeRight: 270,
    };

    /// конвертация
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(event.sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation = orientations[event.cameraController.value.deviceOrientation] ?? 0;
      // todo exeption
      // if (rotationCompensation == null) return null;
      rotationCompensation = (event.sensorOrientation + rotationCompensation) % 360;
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    // todo exeption
    if (rotation == null) return;

    // get image format
    final format = InputImageFormatValue.fromRawValue(event.inputImage.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    // todo exeption
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return;

    // since format is constraint to nv21 or bgra8888, both only have one plane
    // todo exeption
    if (event.inputImage.planes.length != 1) return;
    final plane = event.inputImage.planes.first;

    // compose InputImage using bytes
    InputImage inputImageConverted = InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(event.inputImage.width.toDouble(), event.inputImage.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );

    // Process the image and detect faces.
    final faces = await event.faceDetector.processImage(inputImageConverted);

    for (final face in faces) {
      bool isFaceCentered = _isFaceCentered(face, inputImageConverted.metadata!.size,
          Size(event.inputImage.height.toDouble(), event.inputImage.width.toDouble()));
      // Если лицо в рамке - проверка на моргание
      if (isFaceCentered) {
        newState = newState.setUserFaceInOval(true);

        final leftEyeOpen = face.leftEyeOpenProbability ?? -1;
        final rightEyeOpen = face.rightEyeOpenProbability ?? -1;

        if (leftEyeOpen != -1 && leftEyeOpen < 0.4 && rightEyeOpen != -1 && rightEyeOpen < 0.4) {
          newState = newState.setUserBlinked(true);
        }
      } else {
        newState = newState.setUserFaceInOval(false).setUserBlinked(false);
      }
    }
    emit(newState);
  }
}

bool _isFaceCentered(Face face, Size imageSize, Size cameraSize) {
  double scaleX = 1.0;
  double scaleY = 1.0;
  if (Platform.isAndroid) {
    scaleX = imageSize.width / cameraSize.width;
    scaleY = imageSize.height / cameraSize.height;
  }
  // Scale factors
  // Get the center of the face
  final double faceCenterX = face.boundingBox.center.dx * scaleX;
  final double faceCenterY = face.boundingBox.center.dy * scaleY;
  // Get the center of the image
  final double imageCenterX = imageSize.width / 2;
  final double imageCenterY = imageSize.height / 2.5;
  // Define acceptable range for the face to be considered centered
  final double deltaX = imageSize.width * 0.1; // 10% of the image width
  final double deltaY = imageSize.height * 0.08; // 8% of the image height

  bool result = (faceCenterX > imageCenterX - deltaX && faceCenterX < imageCenterX + deltaX) &&
      (faceCenterY > imageCenterY - deltaY && faceCenterY < imageCenterY + deltaY);

  return result;
}
