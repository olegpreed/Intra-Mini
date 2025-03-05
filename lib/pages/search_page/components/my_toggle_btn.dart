import 'package:flutter/material.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class MyToggleBtn extends StatelessWidget {
  const MyToggleBtn({
    super.key,
    this.text,
    required this.onPressed,
    required this.isPressed,
  });
  final String? text;
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
        width: MediaQuery.of(context).size.width * 0.25,
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
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: !isPressed
                      ? context.myTheme.greyMain
                      : Theme.of(context).cardColor) ??
              const TextStyle(),
          child: Text('$text'),
        ),
      ),
    );
  }
}
