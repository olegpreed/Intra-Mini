import 'package:flutter/material.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';

class SkillPillar extends StatefulWidget {
  const SkillPillar(
      {super.key,
      required this.skillName,
      required this.skillLevel,
      required this.emoji,
      required this.isCurrentPage});
  final String skillName;
  final double skillLevel;
  final String emoji;
  final bool isCurrentPage;

  @override
  State<SkillPillar> createState() => _SkillPillarState();
}

class _SkillPillarState extends State<SkillPillar> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Tooltip(
        message: widget.skillName,
        triggerMode: TooltipTriggerMode.tap,
        preferBelow: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: Layout.cellWidth * 0.4,
              margin: EdgeInsets.only(top: Layout.gutter),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.skillLevel.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: context.myTheme.greySecondary)),
                  Text(' ${widget.emoji} ', textAlign: TextAlign.center),
                ],
              ),
            ),
            Flexible(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.decelerate,
                width: 4,
                height: widget.isCurrentPage
                    ? widget.skillLevel / 21 * (Layout.cellWidth * 0.6)
                    : 0,
                decoration: BoxDecoration(
                    color: context.myTheme.intra.withOpacity(0.2),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
