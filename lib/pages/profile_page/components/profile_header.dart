import 'package:flutter/material.dart';
import 'package:forty_two_planet/pages/profile_page/components/profile_corner_btn.dart';
import 'package:forty_two_planet/pages/profile_page/components/profile_name.dart';
import 'package:forty_two_planet/pages/profile_page/components/profile_online_status.dart';
import 'package:forty_two_planet/pages/profile_page/components/profile_status_tag.dart';
import 'package:forty_two_planet/pages/profile_page/components/profile_avatar.dart';
import 'package:forty_two_planet/pages/profile_page/components/profile_projects.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:provider/provider.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader(
      {super.key,
      required this.isLoading,
      required this.userData,
      required this.isHomeView,
      required this.isShimmerFinished});
  final bool isLoading;
  final UserData userData;
  final bool isHomeView;
  final bool isShimmerFinished;

  @override
  Widget build(BuildContext context) {
    bool isProjectsListExpanded =
        Provider.of<ProjectListState>(context).isExpanded;
    return Padding(
      padding: EdgeInsets.only(
          left: Layout.padding, right: Layout.padding, bottom: Layout.gutter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height:
            !isProjectsListExpanded ? Layout.cellWidth : Layout.cellWidth / 2,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: double.infinity,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Layout.cellWidth / 4),
                ),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: isLoading
                      ? Container()
                      : ProfileAvatar(
                          imageUrl: userData.imageUrlBig,
                          isShimmerFinished: isShimmerFinished,
                          isHomeView: isHomeView,
                        ),
                )),
            SizedBox(width: Layout.gutter),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: !isShimmerFinished ? 0 : 1,
                          child: isLoading
                              ? null
                              : ProfileName(
                                  firstName: userData.firstName,
                                  lastName: userData.lastName),
                        ),
                      ),
                      CornerButton(
                        isHomeView: isHomeView,
                      ),
                    ],
                  ),
                  if (!isLoading)
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      opacity:
                          !isShimmerFinished || isProjectsListExpanded ? 0 : 1,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment:
                            (!userData.isActive! || userData.isStaff!)
                                ? MainAxisAlignment.spaceBetween
                                : MainAxisAlignment.end,
                        children: [
                          if (userData.isActive == false)
                            const ProfileStatusTag(
                              status: 'inactive',
                            ),
                          if (userData.isStaff == true)
                            const ProfileStatusTag(
                              status: 'staff',
                            ),
                          ProfileOnlineStatus(
                            lastSeen: userData.lastSeen,
                            location: userData.location,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
