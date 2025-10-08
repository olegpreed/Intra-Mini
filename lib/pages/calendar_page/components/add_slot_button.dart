import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forty_two_planet/components/pressable_scale.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class AddSlotButton extends StatelessWidget {
  const AddSlotButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onPressed: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: SvgPicture.asset(
          'assets/icons/plus.svg',
          fit: BoxFit.none,
          colorFilter: ColorFilter.mode(
            context.myTheme.greyMain,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
