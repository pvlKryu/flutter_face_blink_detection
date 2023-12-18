import 'dart:async';
import 'package:face_blink_datection/presentation/make_selfie_page/bloc/make_selfie_first_step_event.dart';
import 'package:face_blink_datection/presentation/make_selfie_page/bloc/make_selfie_first_step_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MakeSelfieFirstStepBloc extends Bloc<MakeSelfieFirstStepEvent, MakeSelfieFirstStepState> {
  MakeSelfieFirstStepBloc() : super(MakeSelfieFirstStepState.initial()) {
    on<OnTapContinue>(_onTapContinue);
  }

  FutureOr<void> _onTapContinue(OnTapContinue event, Emitter<MakeSelfieFirstStepState> emit) {
    () => Navigator.pushNamed(event.context, '/second');
  }
}
