import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:forty_two_planet/pages/profile_page/components/log_month_stats.dart';
import 'package:forty_two_planet/utils/class_utils.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class LogBox extends StatefulWidget {
  const LogBox(
      {super.key,
      required this.logtime,
      required this.isLoading,
      required this.isMe});
  final Map<DateTime, List<Pair<Duration, Duration>>> logtime;
  final bool isLoading;
  final bool isMe;

  @override
  State<LogBox> createState() => _LogBoxState();
}

class _LogBoxState extends State<LogBox> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.centerRight, children: [
      Container(
          padding: EdgeInsets.only(left: Layout.cellWidth * 0.1),
          height: Layout.cellWidth,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Layout.cellWidth / 4),
          ),
          child: widget.isLoading
              ? null
              : AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: !widget.isLoading ? 1 : 0,
                  child: FadeIn(
                    duration: const Duration(milliseconds: 300),
                    child: PageView.builder(
                      scrollDirection: Axis.vertical,
                      controller: _pageController,
                      itemCount: widget.logtime.length,
                      itemBuilder: (context, index) {
                        DateTime month = widget.logtime.keys.elementAt(index);
                        List<Pair<Duration, Duration>> monthLogtime =
                            widget.logtime[month]!;
                        return MonthStats(
                          isMe: widget.isMe,
                          month: month,
                          monthLogtime: monthLogtime,
                        );
                      },
                    ),
                  ),
                )),
      Padding(
        padding: EdgeInsets.only(right: Layout.cellWidth * 0.1),
        child: SmoothPageIndicator(
          axisDirection: Axis.vertical,
          controller: _pageController,
          count: widget.logtime.length,
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
