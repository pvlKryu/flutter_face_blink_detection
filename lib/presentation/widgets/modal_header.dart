import 'package:flutter/material.dart';

class ModalHeader extends StatelessWidget {
  final Widget? title;

  final VoidCallback onClosePressed;

  final EdgeInsets? customContentPaddings;

  const ModalHeader({
    Key? key,
    required this.onClosePressed,
    this.title,
    this.customContentPaddings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: customContentPaddings ?? const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(child: title ?? const SizedBox.shrink()),
          const SizedBox(height: 16),
          InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onTap: onClosePressed,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClosePressed,
              )),
        ],
      ),
    );
  }
}
