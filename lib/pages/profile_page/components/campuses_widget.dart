import 'package:flutter/material.dart';
import 'package:forty_two_planet/data/country_flags.dart';
import 'package:forty_two_planet/pages/profile_page/components/campus_page.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CampusesWidget extends StatefulWidget {
  const CampusesWidget(
      {super.key,
      required this.campuses,
      required this.isLoading,
      required this.isShimmerFinished});
  final List<Campus> campuses;
  final bool isLoading;
  final bool isShimmerFinished;

  @override
  State<CampusesWidget> createState() => _CampusesWidgetState();
}

class _CampusesWidgetState extends State<CampusesWidget> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentPage) {
        setState(() {
          _currentPage = page;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String country =
        widget.campuses.isNotEmpty && widget.campuses.length > _currentPage
            ? widget.campuses[_currentPage].country ?? ''
            : '';

    return Stack(alignment: Alignment.centerRight, children: [
      AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          padding: EdgeInsets.symmetric(horizontal: Layout.padding),
          height: Layout.cellWidth,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Layout.cellWidth / 4),
          ),
          foregroundDecoration: BoxDecoration(
            gradient: (!widget.isLoading && widget.isShimmerFinished)
                ? LinearGradient(
                    colors: (countryColors[country] ??
                            [Theme.of(context).cardColor])
                        .map((color) => color.withOpacity(0.2))
                        .toList(),
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)
                : LinearGradient(colors: [
                    Theme.of(context).cardColor,
                    Theme.of(context).cardColor
                  ]),
            borderRadius: BorderRadius.circular(Layout.cellWidth / 4),
          ),
          child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: widget.isShimmerFinished ? 1 : 0,
              child: widget.isLoading
                  ? null
                  : widget.campuses.isEmpty
                      ? Center(
                          child: Text('No campuses yet',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: context.myTheme.greyMain)),
                        )
                      : PageView.builder(
                          itemBuilder: (context, index) {
                            return CampusPage(
                                campusData: widget.campuses[index]);
                          },
                          controller: _pageController,
                          itemCount: widget.campuses.length,
                          scrollDirection: Axis.vertical,
                        ))),
      Padding(
        padding: EdgeInsets.only(right: Layout.cellWidth * 0.1),
        child: SmoothPageIndicator(
          axisDirection: Axis.vertical,
          controller: _pageController,
          count: widget.campuses.length,
          effect: ColorTransitionEffect(
            dotColor: Theme.of(context).scaffoldBackgroundColor,
            activeDotColor: context.myTheme.greyMain,
            dotHeight: Layout.gutter / 1.5,
            dotWidth: Layout.gutter / 1.5,
          ),
        ),
      ),
    ]);
  }
}
