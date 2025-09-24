import 'package:flutter/material.dart';
import 'package:forty_two_planet/pages/profile_page/components/bento_box.dart';
import 'package:forty_two_planet/pages/profile_page/components/bento_icon.dart';
import 'package:forty_two_planet/pages/profile_page/components/circular_progress.dart';
import 'package:forty_two_planet/pages/profile_page/components/profile_projects.dart';
import 'package:forty_two_planet/pages/store_page/store_page.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:provider/provider.dart';

class WidgetsRowOne extends StatelessWidget {
  const WidgetsRowOne(
      {super.key, required this.cadetData, required this.isShimmerFinished});
  final UserData cadetData;
  final bool isShimmerFinished;

  @override
  Widget build(BuildContext context) {
    ProjectListState projectsListProvider =
        Provider.of<ProjectListState>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BentoBox(
          isShimmerFinished: isShimmerFinished,
          content: CircularProgress(
            level:
                cadetData.cursusLevels[projectsListProvider.selectedCursus] ??
                    0.0,
            color: cadetData.coalitionColor,
          ),
        ),
        BentoBox(
          isShimmerFinished: isShimmerFinished,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const BentoIcon(iconPath: 'assets/icons/eval.svg'),
              Text(cadetData.evalPoints.toString(),
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: cadetData.evalPoints < 3
                            ? context.myTheme.fail
                            : null,
                      )),
            ],
          ),
        ),
        BentoBox(
          isShimmerFinished: isShimmerFinished,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const BentoIcon(iconPath: 'assets/icons/wallet.svg'),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) {
                    return StorePage(walletPoints: cadetData.wallet);
                  })));
                },
                child: Text(cadetData.wallet.toString(),
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          decoration: TextDecoration.underline,
                          decorationColor: Theme.of(context).primaryColor,
                        )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
