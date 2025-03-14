import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class ProjectHeader extends StatelessWidget {
  const ProjectHeader(
      {super.key, this.projectName, required this.selectedTeamIndex});
  final String? projectName;
  final int selectedTeamIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: Layout.padding / 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(projectName ?? '',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: selectedTeamIndex == -1
                          ? Theme.of(context).primaryColor
                          : context.myTheme.greyMain,
                    )),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Align(
                alignment: Alignment.center,
                child: SvgPicture.asset('assets/icons/back.svg',
                    colorFilter: ColorFilter.mode(
                        selectedTeamIndex == -1
                            ? Theme.of(context).primaryColor
                            : context.myTheme.greyMain,
                        BlendMode.srcIn)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
