import 'package:flutter/material.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class BottomCalendarSheet extends StatefulWidget {
  const BottomCalendarSheet(
      {super.key, required this.onClose, required this.child, this.color});
  final void Function() onClose;
  final Widget child;
  final Color? color;

  @override
  State<BottomCalendarSheet> createState() => _BottomCalendarSheetState();
}

class _BottomCalendarSheetState extends State<BottomCalendarSheet> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            widget.child,
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTapDown: (TapDownDetails details) {
                widget.onClose();
              },
              onTap: () {
                widget.onClose();
              },
              child: Container(
                width: double.infinity,
                height: 35,
                alignment: Alignment.center,
                child: Container(
                  height: 4,
                  width: 120,
                  decoration: BoxDecoration(
                    color: context.myTheme.greySecondary,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
