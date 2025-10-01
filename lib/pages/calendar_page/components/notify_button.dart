import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forty_two_planet/main.dart';
import 'package:forty_two_planet/pages/calendar_page/components/modal_notification.dart';
import 'package:forty_two_planet/services/campus_data_service.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class NotifyButton extends StatefulWidget {
  const NotifyButton(
      {super.key,
      required this.event,
      required this.isNotified,
      required this.onOk,
      required this.onCancel});
  final dynamic event;
  final bool isNotified;
  final VoidCallback onOk;
  final VoidCallback onCancel;

  @override
  State<NotifyButton> createState() => _NotifyButtonState();
}

class _NotifyButtonState extends State<NotifyButton> {

  @override
  Widget build(BuildContext context) {
     int ?notificationId;
  if (widget.event is Event) {
    notificationId = widget.event.id;
  } else if (widget.event is Slot) {
    notificationId = widget.event.ids[0];
  }
    return GestureDetector(
      onTap: () {
        if (widget.isNotified && notificationId != null) {
          flutterLocalNotificationsPlugin
              .cancel(notificationId)
              .then((_) => widget.onCancel());
          return;
        }
        showDialog(
            context: context,
            builder: (dialogContext) => ModalNotification(
                event: widget.event,
                dialogContext: dialogContext,
                onOk: widget.onOk));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        height: 30,
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width * 0.3,
        ),
        decoration: BoxDecoration(
          color:
              widget.isNotified ? context.myTheme.fail.withOpacity(0.1) : null,
          borderRadius: BorderRadius.circular(10),
          border: widget.isNotified
              ? null
              : Border.all(
                  color: context.myTheme.fail,
                  width: 2,
                ),
        ),
        child: Center(
          child: Row(
            children: [
              SvgPicture.asset(
                widget.isNotified
                    ? 'assets/icons/unbell.svg'
                    : 'assets/icons/bell.svg',
                colorFilter:
                    ColorFilter.mode(context.myTheme.fail, BlendMode.srcIn),
                width: 16,
                height: 16,
              ),
              const SizedBox(width: 8),
              Text(widget.isNotified ? 'unnotify' : 'notify',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: context.myTheme.fail,
                      )),
            ],
          ),
        ),
      ),
    );
  }
}
