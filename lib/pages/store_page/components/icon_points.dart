import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class IconPoints extends StatelessWidget {
  const IconPoints({super.key, required this.points, required this.svgPath});
  final int points;
  final String svgPath;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          svgPath,
          colorFilter:
              ColorFilter.mode(context.myTheme.greySecondary, BlendMode.srcIn),
        ),
        const SizedBox(width: 5),
        Text(
          points.toString(),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: points < 0
                    ? context.myTheme.fail
                    : Theme.of(context).primaryColor,
              ),
        ),
      ],
    );
  }
}
