import 'package:flutter/material.dart';
import 'package:forty_two_planet/pages/profile_page/profile_page.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class UserTag extends StatelessWidget {
  const UserTag({super.key, required this.user, required this.isLeader});
  final String user;
  final bool isLeader;

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage(
                      cadetData: UserData(login: user),
                      isHomeView: false,
                    )),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: context.myTheme.greySecondary.withAlpha(80),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(user),
        ),
      ),
      if (isLeader) const Positioned(top: -14, right: 10, child: Text('👑')),
    ]);
  }
}
