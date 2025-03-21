import 'package:flutter/material.dart';
import 'package:forty_two_planet/pages/profile_page/components/bento_box.dart';
import 'package:forty_two_planet/pages/profile_page/components/bento_icon.dart';
import 'package:forty_two_planet/pages/profile_page/components/circular_progress.dart';
import 'package:forty_two_planet/pages/profile_page/components/skills_widget.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ScrollableCadetData extends StatefulWidget {
  const ScrollableCadetData(
      {super.key,
      required this.cadetData,
      required this.isLoading,
      required this.isShimmerFinished});
  final UserData cadetData;
  final bool isLoading;
  final bool isShimmerFinished;

  @override
  State<ScrollableCadetData> createState() => _ScrollableCadetDataState();
}

class _ScrollableCadetDataState extends State<ScrollableCadetData> {
  final PageController _pageController = PageController();
  List<Widget?> contentsPage1 = [null, null, null];
  List<Widget?> contentsPage2 = [null, null, null];
  int currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      contentsPage1 = [
        CircularProgress(
          level: widget.cadetData.level ?? 0,
          color: widget.cadetData.coalitionColor,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const BentoIcon(iconPath: 'assets/icons/eval.svg'),
            Text(widget.cadetData.evalPoints.toString(),
                style: Theme.of(context).textTheme.headlineLarge),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const BentoIcon(iconPath: 'assets/icons/wallet.svg'),
            Text(widget.cadetData.wallet.toString(),
                style: Theme.of(context).textTheme.headlineLarge),
          ],
        ),
      ];
    }
    contentsPage2 = [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Login',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: context.myTheme.greySecondary)),
          Text(
            widget.cadetData.login ?? '',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Pool year',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: context.myTheme.greySecondary)),
          Text(
            widget.cadetData.poolYear ?? '',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Pool month',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: context.myTheme.greySecondary)),
          Text(
            widget.cadetData.poolMonth ?? '',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    ];

    return Column(
      children: [
        SizedBox(
          height: Layout.cellWidth,
          child: PageView(
              controller: _pageController,
              onPageChanged: (value) => {
                    setState(() {
                      currentPage = value;
                    })
                  },
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Layout.padding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: contentsPage1.map((content) {
                      return BentoBox(
                        isShimmerFinished: widget.isShimmerFinished,
                        content: content,
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Layout.padding),
                  child: SkillsWidget(
                      isCurrentPage: currentPage != 0,
                      isLoading: widget.isLoading,
                      isShimmerFinished: widget.isShimmerFinished,
                      skills: widget.isLoading ? {} : widget.cadetData.skills),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Layout.padding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: contentsPage2.map((content) {
                      return BentoBox(
                        isShimmerFinished: widget.isShimmerFinished,
                        content: content,
                      );
                    }).toList(),
                  ),
                ),
              ]),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: Layout.gutter),
          child: SmoothPageIndicator(
            controller: _pageController,
            count: 3,
            effect: ColorTransitionEffect(
              dotColor: context.myTheme.greySecondary,
              activeDotColor: Theme.of(context).primaryColor,
              dotHeight: Layout.gutter / 1.5,
              dotWidth: Layout.gutter / 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
