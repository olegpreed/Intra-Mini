import 'package:flutter/material.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';

class BentoBox extends StatelessWidget {
  const BentoBox(
      {super.key,
      this.content,
      required this.isShimmerFinished,
      this.hasPadding = true});
  final bool isShimmerFinished;
  final bool hasPadding;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(hasPadding ? Layout.cellWidth * 0.1 : 0),
      alignment: Alignment.center,
      clipBehavior: Clip.hardEdge,
      width: Layout.cellWidth,
      height: Layout.cellWidth,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.all(
          Radius.circular(Layout.cellWidth / 4),
        ),
      ),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: isShimmerFinished ? 1 : 0,
        child: content,
      ),
    );
  }
}
