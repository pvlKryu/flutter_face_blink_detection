import 'package:built_value/built_value.dart';
import 'package:camera/camera.dart';

part 'make_selfie_second_step_page_state.g.dart';

abstract class MakeSelfieSecondStepPageState
    implements Built<MakeSelfieSecondStepPageState, MakeSelfieSecondStepPageStateBuilder> {
  MakeSelfieSecondStepPageState._();

  // пользователь поместил лицо в рамку
  bool get userFaceInOval;

  // пользователь моргнул
  bool get userBlinked;

  bool get error;

  bool get restartImageStream;

  XFile? get photo;

  factory MakeSelfieSecondStepPageState.initial() {
    return MakeSelfieSecondStepPageState((b) => b
      ..userFaceInOval = false
      ..userBlinked = false
      ..photo = null
      ..error = null
      ..restartImageStream = null);
  }

  factory MakeSelfieSecondStepPageState([Function(MakeSelfieSecondStepPageStateBuilder b) updates]) =
      _$MakeSelfieSecondStepPageState;

  MakeSelfieSecondStepPageState setUserFaceInOval(bool flag) => rebuild((b) => b..userFaceInOval = flag);

  MakeSelfieSecondStepPageState setUserBlinked(bool flag) => rebuild((b) => b..userBlinked = flag);

  MakeSelfieSecondStepPageState setPhoto(XFile? img) => rebuild((b) => b..photo = img);

  MakeSelfieSecondStepPageState setError(bool flag) => rebuild((b) => b..error = flag);

  MakeSelfieSecondStepPageState setRestartImageStream(bool flag) => rebuild((b) => b..restartImageStream = flag);
}
