import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class MyToggleBtn extends StatelessWidget {
  const MyToggleBtn({
    super.key,
    required this.svgPath,
    required this.onPressed,
    required this.isPressed,
  });
  final String? svgPath;
  final void Function() onPressed;
  final bool isPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 200),
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color:
              !isPressed ? Colors.transparent : Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: !isPressed
                ? Theme.of(context).scaffoldBackgroundColor
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: SvgPicture.asset(svgPath!),
      ),
    );
  }
}
