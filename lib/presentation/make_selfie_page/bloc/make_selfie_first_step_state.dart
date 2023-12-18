import 'package:built_value/built_value.dart';
part 'make_selfie_first_step_state.g.dart';

abstract class MakeSelfieFirstStepState implements Built<MakeSelfieFirstStepState, MakeSelfieFirstStepStateBuilder> {
  MakeSelfieFirstStepState._();

  factory MakeSelfieFirstStepState.initial() {
    return MakeSelfieFirstStepState((b) => b);
  }

  factory MakeSelfieFirstStepState([void Function(MakeSelfieFirstStepStateBuilder b) updates]) =
      _$MakeSelfieFirstStepState;
}
