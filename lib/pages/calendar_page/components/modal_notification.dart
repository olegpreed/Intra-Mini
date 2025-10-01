import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forty_two_planet/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/settings/user_settings.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:wheel_picker/wheel_picker.dart';
import 'package:timezone/timezone.dart' as tz;

class ModalNotification extends StatefulWidget {
  const ModalNotification(
      {super.key,
      required this.event,
      required this.dialogContext,
      required this.onOk});
  final dynamic event;
  final BuildContext dialogContext;
  final VoidCallback onOk;

  @override
  State<ModalNotification> createState() => _ModalNotificationState();
}

class _ModalNotificationState extends State<ModalNotification> {
  int hoursBefore = 0;
  int minutesBefore = 0;
  bool isSlot = false;

  String getTimeDifference(DateTime start, DateTime end) {
    Duration difference = end.difference(start);
    String result;

    int minutesRounded = (difference.inMinutes ~/ 5) * 5;

    if (difference.inHours >= 1) {
      int hours = difference.inHours;
      int minutes = minutesRounded % 60;
      result = '${hours}h ${minutes}min';
    } else if (minutesRounded > 0) {
      result = '${minutesRounded}min';
    } else {
      result = 'now';
    }

    return result;
  }

  Future<void> scheduleReminder({
    required int id,
    required String title,
    String? body,
    required DateTime eventTime,
    required Duration remindBefore,
  }) async {
    final scheduledDate =
        tz.TZDateTime.from(eventTime, tz.local).subtract(remindBefore);

    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      return;
    }
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder_channel_id',
          'Daily Reminders',
          channelDescription: 'Reminder to complete daily habits',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  @override
  Widget build(BuildContext context) {
    isSlot = widget.event is Slot;
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      contentPadding: const EdgeInsets.all(10),
      backgroundColor: Provider.of<SettingsProvider>(context).isDarkMode
          ? context.myTheme.greySecondary
          : Theme.of(context).scaffoldBackgroundColor,
      title: Center(
          child: Text('Notify me',
              style: Theme.of(context).textTheme.headlineMedium)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: WheelPicker(
                      itemCount: 25,
                      onIndexChanged: (index, interactionType) {
                        HapticFeedback.lightImpact();
                        hoursBefore = index;
                      },
                      builder: (context, index) => Text(index.toString()),
                      looping: true,
                      style: const WheelPickerStyle(
                        surroundingOpacity: 0.3,
                        magnification: 1.5,
                      ),
                    ),
                  ),
                  const Text(
                    'Hours',
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: WheelPicker(
                      itemCount: 12,
                      onIndexChanged: (index, interactionType) {
                        HapticFeedback.lightImpact();
                        minutesBefore = index * 5;
                      },
                      builder: (context, index) => Text((index * 5).toString()),
                      looping: true,
                      style: const WheelPickerStyle(
                        surroundingOpacity: 0.3,
                        magnification: 1.5,
                      ),
                    ),
                  ),
                  const Text('Minutes'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
              'before the ${isSlot ? 'evaluation' : widget.event.isExam ? 'exam' : 'event'}'),
        ],
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).scaffoldBackgroundColor,
              backgroundColor: Theme.of(context).primaryColor),
          onPressed: () {
            Navigator.of(widget.dialogContext).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).scaffoldBackgroundColor,
              backgroundColor: Theme.of(context).primaryColor),
          onPressed: () {
            if (widget.event.beginAt == null) {
              return;
            }
            if (isSlot) {
              if (widget.event.ids.isEmpty) {
                return;
              }
              scheduleReminder(
                id: widget.event.ids[0],
                title: 'Get ready to evaluate 👻',
                body:
                    'in ${getTimeDifference(DateTime.now(), widget.event.beginAt!)}',
                eventTime: widget.event.beginAt!,
                remindBefore:
                    Duration(hours: hoursBefore, minutes: minutesBefore),
              );
            } else {
              if (widget.event.id == null) {
                return;
              }
              scheduleReminder(
                id: widget.event.id!,
                title: widget.event.name ?? 'Event reminder',
                body:
                    '${widget.event.isExam ? 'Exam' : 'Event'} starts in ${getTimeDifference(DateTime.now(), widget.event.beginAt!)}',
                eventTime: widget.event.beginAt!,
                remindBefore:
                    Duration(hours: hoursBefore, minutes: minutesBefore),
              );
            }
            widget.onOk();
            Navigator.of(widget.dialogContext).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
