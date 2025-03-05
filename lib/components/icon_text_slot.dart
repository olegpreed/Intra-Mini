import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class IconTextSlot extends StatelessWidget {
  const IconTextSlot({super.key, required this.svgPath, required this.text});
  final String svgPath;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          svgPath,
          colorFilter: ColorFilter.mode(
              context.myTheme.greyMain,
              BlendMode.srcIn),
        ),
        const SizedBox(width: 4),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.myTheme.greyMain),
            overflow: TextOverflow.fade,
            softWrap: false,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
