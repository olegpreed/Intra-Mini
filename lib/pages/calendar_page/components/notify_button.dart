import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forty_two_planet/pages/calendar_page/components/modal_notification.dart';
import 'package:forty_two_planet/services/campus_data_service.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class NotifyButton extends StatefulWidget {
  const NotifyButton({super.key, required this.event});
  final Event event;

  @override
  State<NotifyButton> createState() => _NotifyButtonState();
}

class _NotifyButtonState extends State<NotifyButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (dialogContext) => ModalNotification(
                event: widget.event, dialogContext: dialogContext));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 30,
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width * 0.3,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: context.myTheme.fail,
            width: 2,
          ),
        ),
        child: Center(
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/bell.svg',
                colorFilter:
                    ColorFilter.mode(context.myTheme.fail, BlendMode.srcIn),
                width: 16,
                height: 16,
              ),
              const SizedBox(width: 5),
              Text('notify',
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
