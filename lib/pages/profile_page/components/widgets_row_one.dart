import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:forty_two_planet/pages/evals_page/evals_page.dart';
import 'package:forty_two_planet/pages/offers_page/offers_page.dart';
import 'package:forty_two_planet/pages/profile_page/components/bento_box.dart';
import 'package:forty_two_planet/pages/profile_page/components/bento_icon.dart';
import 'package:forty_two_planet/pages/profile_page/components/circular_progress.dart';
import 'package:forty_two_planet/pages/profile_page/components/profile_projects.dart';
import 'package:forty_two_planet/pages/store_page/store_page.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class WidgetsRowOne extends StatelessWidget {
  const WidgetsRowOne(
      {super.key,
      required this.cadetData,
      required this.isShimmerFinished,
      required this.keys});
  final UserData cadetData;
  final bool isShimmerFinished;
  final List<GlobalKey> keys;

  @override
  Widget build(BuildContext context) {
    ProjectListState projectsListProvider =
        Provider.of<ProjectListState>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            if (isShimmerFinished == false ||
                cadetData.currentCampusId == null) {
              return;
            }
            Navigator.push(context, MaterialPageRoute(builder: ((context) {
              return OffersPage(campusId: cadetData.currentCampusId!);
            })));
          },
          child: Showcase(
            key: keys[0],
            title:
                'Cadet Level\nTap to see job offers available for your campus',
            child: BentoBox(
              isShimmerFinished: isShimmerFinished,
              content: FadeIn(
                duration: const Duration(milliseconds: 300),
                child: CircularProgress(
                  level: cadetData
                          .cursusLevels[projectsListProvider.selectedCursus] ??
                      0.0,
                  color: cadetData.coalitionColor,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (isShimmerFinished == false || cadetData.id == null) {
              return;
            }
            Navigator.push(context, MaterialPageRoute(builder: ((context) {
              return EvalsPage(userId: cadetData.id!);
            })));
          },
          child: Showcase(
            key: keys[1],
            title: 'Eval points\nTap to see the latest feedbacks made by cadet',
            child: BentoBox(
              isShimmerFinished: isShimmerFinished,
              content: FadeIn(
                duration: const Duration(milliseconds: 300),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const BentoIcon(iconPath: 'assets/icons/eval.svg'),
                    Text(cadetData.evalPoints.toString(),
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  color: cadetData.evalPoints < 3
                                      ? context.myTheme.fail
                                      : null,
                                )),
                  ],
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (isShimmerFinished == false) {
              return;
            }
            Navigator.push(context, MaterialPageRoute(builder: ((context) {
              return StorePage(walletPoints: cadetData.wallet);
            })));
          },
          child: Showcase(
            key: keys[2],
            title: 'Wallet points\nTap to use the Intra Shop calculator',
            child: BentoBox(
              isShimmerFinished: isShimmerFinished,
              content: FadeIn(
                duration: const Duration(milliseconds: 300),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const BentoIcon(iconPath: 'assets/icons/wallet.svg'),
                    Text(cadetData.wallet.toString(),
                        style: Theme.of(context).textTheme.headlineLarge),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
