import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class StoreHeader extends StatelessWidget {
  const StoreHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text('Intra shop', style: Theme.of(context).textTheme.headlineLarge),
      GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: SvgPicture.asset('assets/icons/back.svg',
                fit: BoxFit.none,
                colorFilter: ColorFilter.mode(
                    context.myTheme.greySecondary, BlendMode.srcIn)),
          )),
    ]);
  }
}
