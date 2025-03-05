import 'package:flutter/material.dart';
import 'package:forty_two_planet/services/campus_data_service.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:table_calendar/table_calendar.dart';

class MyCalendar extends StatefulWidget {
  const MyCalendar(
      {super.key,
      required this.events,
      required this.isEvents,
      required this.onTap,
      required this.isExpanded,
      this.startDate,
      this.endDate,
      this.selectedDay,
      this.focusedDay,
      this.format = CalendarFormat.month});
  final Function(DateTime?) onTap;
  final bool isExpanded;
  final List<dynamic> events;
  final bool isEvents;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? selectedDay;
  final CalendarFormat format;
  final DateTime? focusedDay;

  @override
  State<MyCalendar> createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  DateTime now = DateTime.now();
  DateTime? _selectedDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _initializeCalendar();
  }

  void _initializeCalendar() {
    if (!widget.isEvents &&
        widget.selectedDay != null &&
        widget.selectedDay!
            .isAfter(DateTime.now().add(const Duration(days: 14)))) {
      _focusedDay = DateTime.now();
      _selectedDay = null;
    } else {
      _focusedDay = widget.selectedDay ?? DateTime.now();
      _selectedDay = widget.selectedDay;
    }
  }

  @override
  void didUpdateWidget(MyCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isEvents != widget.isEvents ||
        oldWidget.selectedDay != widget.selectedDay ||
        (widget.selectedDay != null &&
            widget.selectedDay!
                .isAfter(DateTime.now().add(const Duration(days: 14))))) {
      _initializeCalendar();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    final cellWidth = (MediaQuery.of(context).size.width - 20) / 7;
    if (widget.selectedDay == null) {
      // Reset the focused and selected day when resetCalendar is true
      _selectedDay = null;
      _focusedDay = DateTime.now();
    }
    return TableCalendar(
      pageAnimationEnabled: true,
      rowHeight: Layout.padding * 2.5,
      headerVisible: true,
      headerStyle: HeaderStyle(
        titleTextStyle: Theme.of(context).textTheme.bodyMedium!,
        headerPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
        leftChevronMargin: EdgeInsets.zero,
        rightChevronMargin: EdgeInsets.zero,
        leftChevronPadding: EdgeInsets.zero,
        rightChevronPadding: EdgeInsets.zero,
        titleCentered: true,
        formatButtonVisible: false,
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: Theme.of(context).cardColor,
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: Theme.of(context).cardColor,
        ),
      ),
      daysOfWeekHeight: cellWidth * 0.4,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      enabledDayPredicate: (day) {
        return !day.isBefore(DateTime.now()
            .subtract(const Duration(days: 1))); // Disable days in the past
      },
      eventLoader: (day) {
        // Check if any event's beginAt matches the current day
        return widget.events.where((event) {
          return event.beginAt != null &&
              isSameDay(event.beginAt!, day); // Check if the dates are the same
        }).toList();
      },
      rangeStartDay: widget.startDate,
      rangeEndDay: widget.endDate,
      firstDay: now,
      lastDay: widget.isEvents
          ? DateTime(now.year, now.month + 6, now.day)
          : DateTime(now.year, now.month, now.day + 14),
      focusedDay: widget.focusedDay ?? _focusedDay,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          if (!widget.isExpanded) {
            _selectedDay = selectedDay; // Select the new day
            widget.onTap(selectedDay);
          }
          _focusedDay = focusedDay; // Update `_focusedDay` here as well
        });
      },
      calendarFormat: widget.format,
      onPageChanged: (focusedDay) => _focusedDay = focusedDay,
      calendarBuilders: CalendarBuilders(
        singleMarkerBuilder: (context, day, event) {
          if (event == null) return Container();
          bool isExam = event is Event ? event.isExam : false;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color:
                  isExam ? context.myTheme.fail : context.myTheme.greySecondary,
              shape: BoxShape.circle,
            ),
            width: 5,
            height: 5,
          );
        },
        dowBuilder: (context, day) {
          final weekday = day.weekday;

          // Check if the day is Saturday (6) or Sunday (7)
          final isWeekend =
              weekday == DateTime.saturday || weekday == DateTime.sunday;

          return Center(
            child: Text(
              [
                'Mon',
                'Tue',
                'Wed',
                'Thu',
                'Fri',
                'Sat',
                'Sun'
              ][weekday - 1], // Display day of the week
              style: TextStyle(
                color: isWeekend
                    ? context.myTheme.intra.withOpacity(0.4)
                    : context.myTheme
                        .greyMain, // Red for weekends, black for weekdays
              ),
            ),
          );
        },
        todayBuilder: (context, day, focusedDay) => Center(
          child: Text(
            '${day.day}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
          ),
        ),
        selectedBuilder: (context, day, focusedDay) {
          if (widget.startDate != null && widget.endDate != null) {
            return Container();
          }
          return Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        rangeStartBuilder: (context, day, focusedDay) {
          return Center(
            child: Container(
              width: cellWidth * 0.8,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.myTheme.intra.withOpacity(1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${day.day}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ),
            ),
          );
        },
        rangeEndBuilder: (context, day, focusedDay) {
          return Center(
            child: Container(
              width: cellWidth * 0.8,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.myTheme.intra.withOpacity(1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${day.day}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ),
            ),
          );
        },
        rangeHighlightBuilder: (context, day, isWithinRange) {
          if (isWithinRange &&
              widget.startDate != null &&
              widget.endDate != null &&
              widget.startDate!.day != widget.endDate!.day) {
            if (widget.startDate != null && widget.startDate!.day == day.day) {
              return Center(
                child: SizedBox(
                  height: cellWidth * 0.8,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: AspectRatio(
                      aspectRatio: 1 / 2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.myTheme.intra.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else if (widget.endDate != null &&
                widget.endDate!.day == day.day) {
              return Center(
                child: SizedBox(
                  height: cellWidth * 0.8,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AspectRatio(
                      aspectRatio: 1 / 2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.myTheme.intra.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Align(
                alignment: Alignment.center,
                child: Container(
                  height: cellWidth * 0.8,
                  decoration: BoxDecoration(
                    color: context.myTheme.intra.withOpacity(0.4),
                  ),
                ),
              );
            }
          }
          return Container();
        },
        defaultBuilder: (context, day, focusedDay) {
          return Center(
              child: Text(
            '${day.day}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
          ));
        },
        disabledBuilder: (context, day, focusedDay) {
          return Center(
            child: Text(
              '${day.day}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).cardColor), // Grey out past days
            ),
          );
        },
      ),
    );
  }
}
