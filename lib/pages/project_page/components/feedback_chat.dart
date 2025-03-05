import 'package:flutter/material.dart';
import 'package:forty_two_planet/pages/profile_page/profile_page.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:intl/intl.dart';

class FeedbackChat extends StatelessWidget {
  const FeedbackChat({super.key, required this.feedback});
  final FeedbackData feedback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(children: [
        Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
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
                      Text(feedback.corrector),
                      const SizedBox(width: 10),
                      Text(DateFormat('d.MM.y').format(feedback.time),
                          style:
                              TextStyle(color: context.myTheme.greySecondary)),
                    ],
                  ),
                  Text(feedback.mark.toString(),
                      style: TextStyle(
                          color: feedback.isFailed
                              ? context.myTheme.fail
                              : context.myTheme.success)),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
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
                child: Text(feedback.comment),
              ),
            ),
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
                  feedback.feedback,
                ),
              ),
            )
          ],
        )
      ]),
    );
  }
}
