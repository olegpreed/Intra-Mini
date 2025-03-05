import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forty_two_planet/pages/project_page/project_page.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/date_utils.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';

class ProjectItem extends StatefulWidget {
  const ProjectItem(
      {super.key,
      required this.projectData,
      required this.userId,
      required this.isLast});
  final ProjectData projectData;
  final int userId;
  final bool isLast;

  @override
  State<ProjectItem> createState() => _ProjectItemState();
}

class _ProjectItemState extends State<ProjectItem> {
  String timeStamp = '';

  @override
  Widget build(BuildContext context) {
    Color? gradeColor;
    SvgPicture? gradeIcon;
    if (widget.projectData.status == 'in_progress' &&
        widget.projectData.validated != true) {
      gradeColor = context.myTheme.greySecondary;
      gradeIcon = SvgPicture.asset(
        'assets/icons/progress.svg',
        colorFilter: ColorFilter.mode(gradeColor, BlendMode.srcIn),
      );
    } else {
      if (widget.projectData.validated == true) {
        gradeColor = context.myTheme.success;
        gradeIcon = SvgPicture.asset(
          'assets/icons/success.svg',
          colorFilter: ColorFilter.mode(gradeColor, BlendMode.srcIn),
        );
      } else if (widget.projectData.validated == false) {
        gradeColor = context.myTheme.fail;
        gradeIcon = SvgPicture.asset(
          'assets/icons/fail.svg',
          colorFilter: ColorFilter.mode(gradeColor, BlendMode.srcIn),
        );
      } else {
        gradeColor = context.myTheme.greySecondary;
        gradeIcon = SvgPicture.asset('assets/icons/progress.svg',
            colorFilter: ColorFilter.mode(gradeColor, BlendMode.srcIn));
      }
    }
    timeStamp = widget.projectData.timeStamp == null
        ? ''
        : timeAgoDetailed(widget.projectData.timeStamp!);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProjectPage(
                  projectId: widget.projectData.projectId,
                  userId: widget.userId,
                  projectName: widget.projectData.name,
                )));
      },
      child: Container(
        padding: EdgeInsets.only(bottom: Layout.gutter * 1.2),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.projectData.name ?? '',
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                    color: Theme.of(context).primaryColor)),
                        SizedBox(height: Layout.padding / 2),
                        Text(timeStamp,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: context.myTheme.greySecondary)),
                      ]),
                ),
                SizedBox(width: Layout.padding / 2),
                Row(
                  children: [
                    if (widget.projectData.finalMark != null)
                      Text('${widget.projectData.finalMark}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(color: gradeColor)),
                    SizedBox(width: Layout.gutter),
                    gradeIcon,
                  ],
                ),
              ],
            ),
            if (widget.isLast == false)
              Container(
                margin: EdgeInsets.only(top: Layout.gutter * 1.2),
                height: 2,
                decoration: BoxDecoration(
                  color: context.myTheme.greySecondary,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
