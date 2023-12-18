import 'package:face_blink_datection/presentation/make_selfie_page/make_selfie_first_step.dart';
import 'package:face_blink_datection/presentation/make_selfie_second_step_page/make_selfie_second_step_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Named Routes Demo',
    initialRoute: '/',
    routes: {
      '/': (context) => const MakeSelfieFirstStepPage(),
      '/second': (context) => const MakeSelfieSecondStepPage(),
    },
  ));
}
