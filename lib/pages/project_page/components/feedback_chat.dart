import 'package:flutter/material.dart';
import 'package:forty_two_planet/data/project_ids.dart';
import 'package:forty_two_planet/pages/profile_page/profile_page.dart';
import 'package:forty_two_planet/pages/project_page/components/user_tag.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/date_utils.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:intl/intl.dart';

class FeedbackChat extends StatelessWidget {
  const FeedbackChat(
      {super.key, required this.feedback, required this.isProjectView});
  final FeedbackData feedback;
  final bool isProjectView;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (!isProjectView)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  projectsByIdsReversed[feedback.projectId] ??
                      'Unknown project',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: projectsByIdsReversed[feedback.projectId] == null
                            ? context.myTheme.greySecondary
                            : null,
                      )),
              SizedBox(height: Layout.gutter),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    for (final user in feedback.correctedTeam.members.keys)
                      Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: UserTag(
                            user: user,
                            isLeader:
                                feedback.correctedTeam.members[user] == true &&
                                    feedback.correctedTeam.members.length > 1,
                          ))
                  ],
                ),
              ),
              SizedBox(height: Layout.gutter),
            ],
          ),
        Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (feedback.corrector == null || !isProjectView) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(
                            cadetData: UserData(login: feedback.corrector),
                            isHomeView: false,
                          )),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (isProjectView)
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(feedback.corrector ?? 'Unknown'),
                        ),
                      if (feedback.startTime != null)
                        Text(DateFormat('d.MM.y').format(feedback.startTime!),
                            style: TextStyle(
                                color: context.myTheme.greySecondary)),
                    ],
                  ),
                  Text(feedback.mark.toString(),
                      style: TextStyle(
                          color: feedback.isFailed == false
                              ? context.myTheme.fail
                              : context.myTheme.success)),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Text(feedback.comment ?? ''),
              ),
              if (feedback.startTime != null && feedback.endTime != null)
                Text(formatDuration(feedback.startTime!, feedback.endTime!),
                    style: TextStyle(color: context.myTheme.greySecondary)),
            ]),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.myTheme.greySecondary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Text(
                  feedback.feedback ?? '',
                ),
              ),
            )
          ],
        )
      ]),
    );
  }
}
