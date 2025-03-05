import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class SortBtn extends StatelessWidget {
  const SortBtn({super.key, this.onPressed, required this.isAscending});
  final void Function()? onPressed;
  final bool isAscending;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        // color: Theme.of(context).cardColor,
        border: Border.all(
          color: Theme.of(context).scaffoldBackgroundColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: IconButton(
          onPressed: onPressed,
          icon: AnimatedRotation(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            turns: isAscending ? 0.5 : 0,
            child: SvgPicture.asset('assets/icons/sort_arrow.svg',
                fit: BoxFit.none,
                colorFilter: ColorFilter.mode(
                    context.myTheme.greyMain, BlendMode.srcIn)),
          )),
    );
  }
}
