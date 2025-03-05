import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';

class BentoIcon extends StatelessWidget {
  const BentoIcon({super.key, required this.iconPath, this.color});
  final String iconPath;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Layout.cellWidth / 3,
      width: Layout.cellWidth / 3,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(50)),
      child: Center(
        child: SvgPicture.asset(
          iconPath,
          colorFilter: ColorFilter.mode(
              color ?? context.myTheme.greyMain, BlendMode.srcIn),
          fit: BoxFit.scaleDown,
          width: Layout.cellWidth / 5,
        ),
      ),
    );
  }
}
