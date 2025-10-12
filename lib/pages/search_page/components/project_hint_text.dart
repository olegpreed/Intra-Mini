import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/class_utils.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';

class ProjectHintText extends StatelessWidget {
  const ProjectHintText({super.key});

  @override
  Widget build(BuildContext context) {
    List<Pair<String, String>> statuses = [
      Pair('unlocked', 'Team is not locked'),
      Pair('locked', 'Team is locked'),
      Pair('finished', 'Project is finished'),
    ];
    Color color = context.myTheme.greySecondary;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Layout.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '1. Enter a project in the search',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '2. Choose a project status',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color,
                ),
          ),
          for (var status in statuses)
            Padding(
              padding: const EdgeInsets.only(left: 24.0, top: 4, bottom: 4),
              child: Row(
                children: [
                  Text('• ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: color,
                          )),
                  SvgPicture.asset(
                    'assets/icons/${status.first}.svg',
                    width: 16,
                    height: 16,
                    colorFilter: ColorFilter.mode(
                      color,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    status.second,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: color,
                        ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
