import 'package:face_blink_datection/presentation/make_selfie_page/bloc/make_selfie_first_step_bloc.dart';
import 'package:face_blink_datection/presentation/make_selfie_page/bloc/make_selfie_first_step_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MakeSelfieFirstStepPage extends StatefulWidget {
  const MakeSelfieFirstStepPage({super.key});

  @override
  State<MakeSelfieFirstStepPage> createState() => _MakeSelfieFirstStepPageState();
}

class _MakeSelfieFirstStepPageState extends State<MakeSelfieFirstStepPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MakeSelfieFirstStepBloc, MakeSelfieFirstStepState>(builder: (context, state) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('12'),
          ),

          //  HeaderInner(
          //   title: localization.makeSelfie,
          //   onBackButtonPressed: () => context.read<MakeSelfieFirstStepBloc>().add(OnTapBack()),
          // ),
          body: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // const Gap(112),
                  // const AtbImage(assetPath: UiAssets.illustrationPhoto),
                  // const Gap(32),
                  // Text(
                  //   localization.photoYourself,
                  //   style: context.textTheme.bodyLarge?.copyWith(color: colors?.neutral[10]),
                  // ),
                  // const Gap(112),
                  // AlertInfo(
                  //     leading: AtbIcon(assetPath: UiAssets.faceId24, color: colors?.success[30]),
                  //     text: localization.yourPhotoIncreases),
                  // const Gap(32),
                  // // todo bloc
                  // AtbButton(
                  //   title: localization.takePhoto,
                  //   size: AtbButtonSize.large,
                  //   onPressed: () => context.read<MakeSelfieFirstStepBloc>().add(OnTapContinue()),
                  // ),
                  // const Gap(16),
                  // // todo bloc
                  // AtbButton(
                  //   title: localization.skip,
                  //   size: AtbButtonSize.large,
                  //   type: AtbButtonType.textButton,
                  //   onPressed: () => (),
                  // ),
                  // const Gap(24),
                ],
              ),
            ),
          ));
    });
  }
}
