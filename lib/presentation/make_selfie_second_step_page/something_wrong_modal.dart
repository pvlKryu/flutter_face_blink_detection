import 'package:face_blink_datection/presentation/widgets/modal_alert.dart';
import 'package:face_blink_datection/resources/text_resources.dart';
import 'package:flutter/material.dart';

class SomethingWrongModalSheet extends StatelessWidget {
  const SomethingWrongModalSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ModalAlert(
        topWidget: const Icon(Icons.warning_rounded),
        title: TextResources.somethingWentWrong,
        subTitle: TextResources.pleaseTakePhotoAgain,
        bottomWidget: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(TextResources.retakePhoto),
        ),
        cancelCallback: () => Navigator.pop(context),
      ),
    );
  }
}
