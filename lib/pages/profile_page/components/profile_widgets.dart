import 'package:flutter/material.dart';
import 'package:forty_two_planet/pages/profile_page/components/log_box.dart';
import 'package:forty_two_planet/pages/profile_page/components/scrollable_cadet_data.dart';
import 'package:forty_two_planet/pages/profile_page/components/profile_projects.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:forty_two_planet/components/shimmer_loading.dart';
import 'package:provider/provider.dart';

class ProfileWidgets extends StatelessWidget {
  const ProfileWidgets(
      {super.key, required this.userData, required this.isLoading});
  final UserData userData;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    bool isProjectsListExpanded =
        Provider.of<ProjectListState>(context).isExpanded;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isProjectsListExpanded ? 0 : 1,
      child: Column(
        children: [
          ScrollableCadetData(cadetData: userData, isLoading: isLoading),
          ShimmerLoading(
            isLoading: isLoading,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Layout.padding),
              child: LogBox(
                isMe: userData.id ==
                    Provider.of<MyProfileStore>(context).userData.id,
                isLoading: isLoading,
                logtime: userData.weeklyLogTimesByMonth,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
