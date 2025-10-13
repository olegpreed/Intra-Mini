import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:forty_two_planet/pages/profile_page/components/log_column.dart';
import 'package:forty_two_planet/settings/user_settings.dart';
import 'package:forty_two_planet/utils/class_utils.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/date_utils.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MonthStats extends StatelessWidget {
  const MonthStats(
      {super.key,
      required this.month,
      required this.monthLogtime,
      required this.isMe,
      required this.keys});
  final DateTime month;
  final List<Pair<Duration, Duration>> monthLogtime;
  final bool isMe;
  final List<GlobalKey> keys;

  @override
  Widget build(BuildContext context) {
    Duration averageWeektime = calcAverageWeekTime(monthLogtime, month);
    int weekGoal = Provider.of<SettingsProvider>(context).get('logtimeGoal');
    return Row(children: [
      Expanded(
        child: SizedBox(
          height: Layout.cellWidth * 0.7,
          child: Stack(alignment: Alignment.bottomCenter, children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(monthLogtime.length, (indexWeek) {
                  return LogColumn(
                      showcaseKey: keys[0],
                      month: month,
                      indexWeek: indexWeek,
                      monthLogtime: monthLogtime);
                })),
            if (isMe)
              IgnorePointer(
                child: ClipRRect(
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 1.1,
                    heightFactor: Provider.of<SettingsProvider>(context)
                            .get('logtimeGoal') /
                        60,
                    child: DottedLine(
                      alignment: WrapAlignment.start,
                      direction: Axis.horizontal,
                      lineLength: double.infinity,
                      lineThickness: 3,
                      dashLength: 8,
                      dashGapLength: 4,
                      dashRadius: 1,
                      dashColor: context.myTheme.fail,
                    ),
                  ),
                ),
              ),
          ]),
        ),
      ),
      ShowCaseWrapper(
        isShowcase: DateTime.now().month == month.month,
        showcaseKey: keys[1],
        title: 'This is your average log time per week for this month.',
        child: Container(
          alignment: Alignment.center,
          width: Layout.cellWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(DateFormat('MMM').format(month),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: context.myTheme.greySecondary)),
              SizedBox(height: Layout.gutter / 2),
              Text('${averageWeektime.inHours}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: weekGoal != 0
                            ? averageWeektime.inHours >= weekGoal
                                ? context.myTheme.success
                                : context.myTheme.fail
                            : averageWeektime.inHours == 0
                                ? context.myTheme.greySecondary
                                : Theme.of(context).primaryColor,
                      )),
              Text('hours',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: context.myTheme.greySecondary)),
            ],
          ),
        ),
      ),
    ]);
  }
}
