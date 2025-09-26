import 'package:flutter/material.dart';
import 'package:forty_two_planet/pages/profile_page/components/bento_box.dart';
import 'package:forty_two_planet/pages/profile_page/components/campuses_widget.dart';
import 'package:forty_two_planet/pages/profile_page/components/skills_widget.dart';
import 'package:forty_two_planet/pages/profile_page/components/widgets_row_one.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/components/shimmer_loading.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ScrollableCadetData extends StatefulWidget {
  const ScrollableCadetData(
      {super.key, required this.cadetData, required this.isLoading});
  final UserData cadetData;
  final bool isLoading;

  @override
  State<ScrollableCadetData> createState() => _ScrollableCadetDataState();
}

class _ScrollableCadetDataState extends State<ScrollableCadetData> {
  final PageController _pageController = PageController(initialPage: 1);
  List<Widget?> contentsPage2 = [null, null, null];
  int currentPage = 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

    return ShimmerLoading(
      isLoading: widget.cadetData.cursusLevels.isEmpty && widget.isLoading,
      child: Column(
        children: [
          SizedBox(
            height: Layout.cellWidth,
            child: PageView(
                physics: widget.isLoading
                    ? const NeverScrollableScrollPhysics()
                    : null,
                controller: _pageController,
                onPageChanged: (value) => {
                      setState(() {
                        currentPage = value;
                      })
                    },
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: Layout.padding),
                      child: CampusesWidget(
                          isLoading: widget.isLoading,
                          campuses: widget.cadetData.campuses)),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: Layout.padding),
                      child: WidgetsRowOne(
                        cadetData: widget.cadetData,
                        isLoading: widget.isLoading,
                        isShimmerFinished:
                            widget.cadetData.cursusLevels.isNotEmpty ||
                                !widget.isLoading,
                      )),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Layout.padding),
                    child: SkillsWidget(
                        isCurrentPage: currentPage != 1,
                        isLoading: widget.isLoading,
                        isShimmerFinished: !widget.isLoading,
                        skills:
                            widget.isLoading ? {} : widget.cadetData.skills),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Layout.padding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: contentsPage2.map((content) {
                        return BentoBox(
                          isShimmerFinished: !widget.isLoading,
                          content: content,
                        );
                      }).toList(),
                    ),
                  ),
                ]),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: Layout.gutter),
            child: AnimatedCrossFade(
              alignment: Alignment.center,
              duration: const Duration(milliseconds: 300),
              crossFadeState: widget.isLoading
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild:
                  SizedBox(height: Layout.gutter / 1.5, width: double.infinity),
              secondChild: SmoothPageIndicator(
                controller: _pageController,
                count: 4,
                effect: ColorTransitionEffect(
                  dotColor: context.myTheme.greySecondary,
                  activeDotColor: Theme.of(context).primaryColor,
                  dotHeight: Layout.gutter / 1.5,
                  dotWidth: Layout.gutter / 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
