import 'package:flutter/material.dart';
import 'package:forty_two_planet/pages/project_page/components/feedback_chat.dart';
import 'package:forty_two_planet/pages/project_page/components/user_tag.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:loading_indicator/loading_indicator.dart';

class TeamCard extends StatefulWidget {
  const TeamCard(
      {super.key,
      required this.team,
      required this.projectId,
      required this.index,
      required this.onTap,
      required this.selectedIndex});
  final int index;
  final TeamData team;
  final int projectId;
  final Function(int) onTap;
  final int selectedIndex;

  @override
  State<TeamCard> createState() => _TeamCardState();
}

class _TeamCardState extends State<TeamCard> {
  bool isExpanded = false;
  bool isLoading = false;
  List<FeedbackData> feedbacks = [];

  Future<void> onTeamTap() async {
    if (isExpanded) {
      widget.onTap(-1);
      setState(() {
        isExpanded = false;
      });
    } else {
      widget.onTap(widget.index);
      setState(() {
        isExpanded = true;
      });
      if (feedbacks.isNotEmpty) {
        return;
      }
      if (!mounted) {
        return;
      }
      setState(() {
        isLoading = true;
      });
      try {
        feedbacks =
            await UserService.fetchFeedbacks(widget.projectId, widget.team.id!);
      } catch (e) {
        if (!mounted) return;
        showErrorDialog(e.toString());
        setState(() {
          isExpanded = false;
        });
      }
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedIndex != widget.index) {
      isExpanded = false;
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onTeamTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(widget.team.name ?? '',
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              maxLines: 1,
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
                        ),
                        const SizedBox(width: 10),
                        if (isLoading)
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: LoadingIndicator(
                              indicatorType: Indicator.lineSpinFadeLoader,
                              colors: [context.myTheme.greySecondary],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                        widget.team.finalMark != null
                            ? widget.team.finalMark.toString()
                            : '',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                                color: widget.team.isFailed == true
                                    ? context.myTheme.fail
                                    : context.myTheme.success)),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeInOut,
                child: isExpanded
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final user in (widget.team.members.keys))
                              UserTag(
                                  user: user,
                                  isLeader: widget.team.members[user] ?? false),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              if (isExpanded) const SizedBox(height: 10),
              AnimatedSize(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                child: !isLoading && isExpanded
                    ? Column(children: [
                        for (final feedback in feedbacks)
                          FeedbackChat(feedback: feedback)
                      ])
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
