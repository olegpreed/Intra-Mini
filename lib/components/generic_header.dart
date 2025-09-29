import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class GenericHeader extends StatelessWidget {
  const GenericHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title, style: Theme.of(context).textTheme.headlineLarge),
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
