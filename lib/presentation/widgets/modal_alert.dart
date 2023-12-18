import 'package:face_blink_datection/presentation/widgets/modal_header.dart';
import 'package:flutter/material.dart';

class ModalAlert extends StatelessWidget {
  final VoidCallback cancelCallback;

  final Widget? headerTitle;

  final Widget topWidget;

  final String? title;

  final String? subTitle;

  final Widget? bottomWidget;

  const ModalAlert({
    super.key,
    required this.cancelCallback,
    required this.topWidget,
    this.headerTitle,
    this.title,
    this.subTitle,
    this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ModalHeader(title: headerTitle ?? const SizedBox.shrink(), onClosePressed: cancelCallback),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                topWidget,
                const SizedBox(height: 24),
                if (title != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Text(title ?? "", style: textTheme.titleLarge, textAlign: TextAlign.center),
                  ),
                subTitle != null
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Text(subTitle ?? "", style: textTheme.bodyLarge, textAlign: TextAlign.center),
                      )
                    : const SizedBox(height: 12),
                if (bottomWidget != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: bottomWidget,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
