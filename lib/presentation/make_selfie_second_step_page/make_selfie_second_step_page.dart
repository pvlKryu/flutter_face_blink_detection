import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:face_blink_datection/presentation/make_selfie_second_step_page/bloc/make_selfie_second_step_page_bloc.dart';
import 'package:face_blink_datection/presentation/make_selfie_second_step_page/bloc/make_selfie_second_step_page_event.dart';
import 'package:face_blink_datection/presentation/make_selfie_second_step_page/bloc/make_selfie_second_step_page_state.dart';
import 'package:face_blink_datection/presentation/make_selfie_second_step_page/something_wrong_modal.dart';
import 'package:face_blink_datection/resources/text_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class MakeSelfieSecondStepPage extends StatefulWidget {
  const MakeSelfieSecondStepPage({super.key});

  @override
  State<MakeSelfieSecondStepPage> createState() => _MakeSelfieSecondStepPageState();
}

class _MakeSelfieSecondStepPageState extends State<MakeSelfieSecondStepPage> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ),
  );
  static List<CameraDescription> _cameras = [];
  CameraController? _controller;
  int _cameraIndex = -1;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _initialize();
  }

  @override
  void dispose() {
    _stopLiveFeed();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    _faceDetector.close();
    super.dispose();
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  void _initialize() async {
    try {
      _cameras = await availableCameras();
      for (var i = 0; i < _cameras.length; i++) {
        if (_cameras[i].lensDirection == CameraLensDirection.front) {
          _cameraIndex = i;
          break;
        }
      }

      if (_cameraIndex == -1) {
        context.read<MakeSelfieSecondStepPageBloc>().add(OnCameraErrorEvent());
      } else {
        final camera = _cameras[_cameraIndex];
        _controller = CameraController(
          camera,
          // Do NOT set it to ResolutionPreset.max because for some phones does NOT work.
          ResolutionPreset.high,
          enableAudio: false,
          imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
        );
        await _controller?.initialize();
        setState(() {});

        if (!mounted) return;

        _controller?.startImageStream(_processCameraImage);
      }
    } catch (e) {
      context.read<MakeSelfieSecondStepPageBloc>().add(OnCameraErrorEvent());
    }
  }

  void _processCameraImage(CameraImage image) {
    if (_controller != null) {
      final camera = _cameras[_cameraIndex];
      final sensorOrientation = camera.sensorOrientation;

      context.read<MakeSelfieSecondStepPageBloc>().add(CameraImageEvent(
          inputImage: image,
          faceDetector: _faceDetector,
          cameraController: _controller!,
          sensorOrientation: sensorOrientation));
    } else {
      context.read<MakeSelfieSecondStepPageBloc>().add(OnCameraErrorEvent());
    }
  }

  // void onNewsReceived(BlocNews news) async {
  //   if (news is SomethingWentWrongBlocNews) {}
  //   if (news is CameraControllerStartStreamBlocNews) {
  //     await _controller?.startImageStream(_processCameraImage);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final ovalWidth = screenSize.width * 0.87;
    final ovalHeight = screenSize.height * 0.57;

    return Scaffold(
      appBar: AppBar(
        title: const Text('12'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.read<MakeSelfieSecondStepPageBloc>().add(OnTapBackEvent(context: context))),
      ),
      body: BlocBuilder<MakeSelfieSecondStepPageBloc, MakeSelfieSecondStepPageState>(builder: (context, state) {
        if (state.error) {
          showModalBottomSheet(
            useRootNavigator: true,
            context: context,
            builder: (context) {
              return const SomethingWrongModalSheet();
            },
          );
          Navigator.pop(context);
        }
        if (state.restartImageStream) {
          _controller?.startImageStream(_processCameraImage);
        }
        return Stack(
          children: [
            // Изображение с камеры или фото
            (state.photo == null) ? _buildCameraPreview() : _buildPhotoPreview(state.photo as XFile),
            if (!(_cameras.isEmpty || _controller == null || _controller?.value.isInitialized == false))
              Positioned.fill(
                child: ClipPath(
                  clipper: InvertedOvalClipper(ovalWidth: ovalWidth, ovalHeight: ovalHeight),
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
                  ),
                ),
              ),
            Positioned(left: 0, right: 0, bottom: 0, child: _buildBottomWidget(state))
          ],
        );
      }),
    );
  }

  Widget _buildBottomWidget(MakeSelfieSecondStepPageState state) {
    final bool hasBlinked = state.userBlinked;
    final bool isFaceInOval = state.userFaceInOval;
    final bool showButton = hasBlinked && isFaceInOval;
    final bool hasPhotoTaken = state.photo != null;

    if (!hasPhotoTaken) {
      if (showButton) {
        return Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextButton(onPressed: _takePicture, child: const Text(TextResources.takePhoto)));
      } else {
        return Container(
          width: double.infinity,
          height: 72,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          color: Colors.amber,
          child: Center(
            child: Text(
              isFaceInOval ? TextResources.blinkBeforePhoto : TextResources.faceMustBeInOval,
            ),
          ),
        );
      }
    } else {
      // Блок кнопок "Отправить фото" и "Переснять"
      return Container(
        color: Colors.amber,
        height: 160,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(children: [
          TextButton(
              onPressed: () => context.read<MakeSelfieSecondStepPageBloc>().add(OnTapSendPhotoEvent()),
              child: const Text(TextResources.sendPhoto)),
          const SizedBox(height: 16),
          TextButton(
              onPressed: () => context.read<MakeSelfieSecondStepPageBloc>().add(OnTapMakePhotoAgainEvent()),
              child: const Text(TextResources.retakePhoto)),
        ]),
      );
    }
  }

  Widget _buildCameraPreview() {
    if (_cameras.isEmpty || _controller == null || _controller?.value.isInitialized == false) {
      return const Center(
        child: CircularProgressIndicator(value: 88, strokeWidth: 8.0),
      );
    } else {
      final size = _controller?.value.previewSize ?? const Size(1, 1);
      final aspectRatio = size.height / size.width;
      return Center(
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: CameraPreview(_controller!),
        ),
      );
    }
  }

  Widget _buildPhotoPreview(XFile photo) {
    final file = File(photo.path);
    if (!file.existsSync()) {
      context.read<MakeSelfieSecondStepPageBloc>().add(OnCameraErrorEvent());
    }
    return Center(child: Image.file(file));
  }

  Future<void> _takePicture() async {
    try {
      await _controller?.stopImageStream();
      final XFile? image = await _controller?.takePicture();
      if (image != null) {
        context.read<MakeSelfieSecondStepPageBloc>().add(OnTapMakePhotoEvent(photo: image));
      }
    } catch (e) {
      context.read<MakeSelfieSecondStepPageBloc>().add(OnCameraErrorEvent());
    }
  }
}

// Оверлей овальная рамка
class InvertedOvalClipper extends CustomClipper<Path> {
  final double ovalWidth;
  final double ovalHeight;

  InvertedOvalClipper({required this.ovalWidth, required this.ovalHeight});

  @override
  Path getClip(Size size) {
    Path path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    Path ovalPath = Path()
      ..addOval(Rect.fromCenter(
        center: Offset(size.width / 2, ovalHeight / 2 + 48),
        width: ovalWidth,
        height: ovalHeight,
      ));
    return Path.combine(PathOperation.difference, path, ovalPath);
  }

  @override
  bool shouldReclip(InvertedOvalClipper oldClipper) =>
      ovalWidth != oldClipper.ovalWidth || ovalHeight != oldClipper.ovalHeight;
}
