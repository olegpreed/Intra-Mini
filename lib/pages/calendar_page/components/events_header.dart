import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:intl/intl.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class EventsHeader extends StatelessWidget {
  const EventsHeader(
      {super.key,
      required this.selectedDay,
      required this.isEvents,
      required this.onClose});
  final DateTime? selectedDay;
  final bool isEvents;
  final Function() onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Layout.gutter),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            selectedDay != null
                ? DateFormat('d MMMM, EEEE').format(selectedDay!)
                : 'All ${isEvents ? 'events' : 'slots'}',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: context.myTheme.greyMain),
          ),
          selectedDay != null
              ? GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: onClose,
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: SvgPicture.asset(
                      'assets/icons/x.svg',
                      colorFilter: ColorFilter.mode(
                        context.myTheme.greyMain,
                        BlendMode.srcIn,
                      ),
                    ),
                  ))
              : Container(),
        ],
      ),
    );
  }
}
