import 'package:flutter/material.dart';
import 'package:forty_two_planet/pages/profile_page/components/log_column_fill.dart';
import 'package:forty_two_planet/pages/profile_page/components/log_column_hint.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/class_utils.dart';
import 'package:forty_two_planet/utils/date_utils.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:showcaseview/showcaseview.dart';

class LogColumn extends StatelessWidget {
  const LogColumn(
      {super.key,
      required this.month,
      required this.showcaseKey,
      required this.indexWeek,
      required this.monthLogtime});
  final DateTime month;
  final int indexWeek;
  final List<Pair<Duration, Duration>> monthLogtime;
  final GlobalKey showcaseKey;

  @override
  Widget build(BuildContext context) {
    DateTime startDate =
        getFirstDayOfWeek(month.add(Duration(days: indexWeek * 7)));
    DateTime endDate = getLastDayOfWeek(startDate.add(const Duration(days: 6)));
    double logtimeThisMonth = monthLogtime[indexWeek].first.inHours +
        ((monthLogtime[indexWeek].first.inMinutes % 60) / 60);
    double logtimeOtherMonth = monthLogtime[indexWeek].second.inHours +
        ((monthLogtime[indexWeek].second.inMinutes % 60) / 60);
    bool isCurrentWeek = month.month == DateTime.now().month &&
        indexWeek == getWeekNumber(DateTime.now()) - 1;
    return LogColumnHint(
      startDate: startDate,
      endDate: endDate,
      logtime: logtimeThisMonth + logtimeOtherMonth,
      child: ShowCaseWrapper(
        title:
            'This is your log time for this week.\nIt gets updated every day.\nThe maximum value is 60 hours.\nYou can tap on each column to see more details.',
        isShowcase: isCurrentWeek,
        showcaseKey: showcaseKey,
        child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: context.myTheme.intra.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: LogFillColumn(
                          logtime: logtimeThisMonth + logtimeOtherMonth,
                          ratio: logtimeThisMonth /
                              (logtimeThisMonth + logtimeOtherMonth),
                          firstWeek: indexWeek == 0,
                          lastWeek: indexWeek == monthLogtime.length - 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (isCurrentWeek)
                Positioned(
                  bottom: -Layout.cellWidth * 0.1,
                  child: Container(
                    height: Layout.cellWidth * 0.05,
                    width: Layout.cellWidth * 0.05,
                    decoration: BoxDecoration(
                      color: context.myTheme.greySecondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ]),
      ),
    );
  }
}

class ShowCaseWrapper extends StatelessWidget {
  const ShowCaseWrapper(
      {super.key,
      required this.isShowcase,
      required this.showcaseKey,
      required this.child,
      required this.title});
  final bool isShowcase;
  final GlobalKey showcaseKey;
  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    return isShowcase
        ? Showcase(
            key: showcaseKey,
            title: title,
            child: child,
          )
        : child;
  }
}
