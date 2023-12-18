import 'package:flutter/material.dart';

sealed class MakeSelfieFirstStepEvent {}

/// событие перехода на следующий экран
class OnTapContinue extends MakeSelfieFirstStepEvent {
  final BuildContext context;

  OnTapContinue({required this.context});
}

/// событие нажатия кнопки пропустить
class OnTapSkip extends MakeSelfieFirstStepEvent {}
