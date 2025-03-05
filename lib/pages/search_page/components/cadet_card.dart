import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:forty_two_planet/components/default_avatar.dart';
import 'package:forty_two_planet/pages/search_page/components/frozen_tag.dart';
import 'package:forty_two_planet/pages/search_page/components/online_tag.dart';
import 'package:forty_two_planet/pages/profile_page/profile_page.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/date_utils.dart';

class CadetCard extends StatelessWidget {
  const CadetCard(
      {super.key,
      required this.cadetData,
      this.projectData,
      required this.projectStatus});
  final UserData cadetData;
  final SearchProjectData? projectData;
  final String? projectStatus;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfilePage(
                    cadetData: cadetData,
                    isHomeView: false,
                  )),
        );
      },
      child: Container(
        height: 75,
        padding: const EdgeInsets.only(left: 4),
        margin: const EdgeInsets.only(bottom: 7),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
              ),
              child: cadetData.imageUrlSmall != null
                  ? CachedNetworkImage(
                      imageUrl: cadetData.imageUrlSmall!,
                      width: 67,
                      height: 67,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const SizedBox(
                        width: 67,
                        height: 67,
                      ),
                      errorWidget: (context, url, error) => const SizedBox(
                        width: 67,
                        height: 67,
                        child: DefaultAvatar(),
                      ),
                      fadeInDuration: const Duration(milliseconds: 200),
                    )
                  : const SizedBox(
                      height: 67, width: 67, child: DefaultAvatar())),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  left: 8,
                  top: projectData != null ? 4.0 : 0,
                  bottom: projectData != null ? 8.0 : 0,
                  right: projectData != null ? 12.0 : 0),
              child: Stack(children: [
                if (cadetData.location != null)
                  Align(
                      alignment: Alignment.center,
                      child: OnlineTag(location: cadetData.location)),
                if (cadetData.isActive == false)
                  const Align(alignment: Alignment.center, child: FrozenTag()),
                if (projectData != null)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: projectData!.teamName != null
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.end,
                      children: [
                        if (projectData!.teamName != null)
                          Expanded(
                            child: Text(
                              '${projectData!.teamName}',
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: context.myTheme.greyMain,
                                  ),
                            ),
                          ),
                        if (projectStatus != 'creating_group,searching_a_group')
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              timeAgoDetailed(projectData!.timeStamp!),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: context.myTheme.greyMain,
                                  ),
                            ),
                          ),
                      ],
                    ),
                  ),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${cadetData.login}',
                            style: Theme.of(context).textTheme.bodyMedium),
                        if (projectData == null)
                          ClipRect(
                            child: SizedBox(
                              width: 120,
                              height: 75,
                              child: OverflowBox(
                                maxWidth: double.infinity,
                                maxHeight: double.infinity,
                                child: Text(
                                  '${cadetData.level?.truncate()}',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: 105,
                                      letterSpacing: -10,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor),
                                ),
                              ),
                            ),
                          ),
                        if (projectData != null && projectStatus == 'finished')
                          Text(
                            '${projectData!.finalMark ?? ''}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .copyWith(
                                    color: projectData!.isFailed == true
                                        ? context.myTheme.fail
                                        : context.myTheme.success),
                          ),
                      ]),
                ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
