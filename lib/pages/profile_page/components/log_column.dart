import 'package:flutter/material.dart';
import 'package:forty_two_planet/pages/profile_page/components/log_column_fill.dart';
import 'package:forty_two_planet/pages/profile_page/components/log_column_hint.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/class_utils.dart';
import 'package:forty_two_planet/utils/date_utils.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';

class LogColumn extends StatelessWidget {
  const LogColumn(
      {super.key,
      required this.month,
      required this.indexWeek,
      required this.monthLogtime});
  final DateTime month;
  final int indexWeek;
  final List<Pair<Duration, Duration>> monthLogtime;

  @override
  Widget build(BuildContext context) {
    DateTime startDate =
        getFirstDayOfWeek(month.add(Duration(days: indexWeek * 7)));
    DateTime endDate = getLastDayOfWeek(startDate.add(const Duration(days: 6)));
    double logtimeThisMonth = monthLogtime[indexWeek].first.inHours +
        ((monthLogtime[indexWeek].first.inMinutes % 60) / 60);
    double logtimeOtherMonth = monthLogtime[indexWeek].second.inHours +
        ((monthLogtime[indexWeek].second.inMinutes % 60) / 60);
    return LogColumnHint(
      startDate: startDate,
      endDate: endDate,
      logtime: logtimeThisMonth + logtimeOtherMonth,
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
            if (month.month == DateTime.now().month &&
                indexWeek == getWeekNumber(DateTime.now()) - 1)
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
    );
  }
}
