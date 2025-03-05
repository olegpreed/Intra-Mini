import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forty_two_planet/components/icon_text_slot.dart';
import 'package:forty_two_planet/components/time_ago.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

class SlotCard extends StatefulWidget {
  const SlotCard({super.key, required this.slot});
  final Slot slot;

  @override
  State<SlotCard> createState() => _SlotCardState();
}

class _SlotCardState extends State<SlotCard> {
  bool isDeleting = false;

  String getTimeDifference(DateTime start, DateTime end) {
    Duration difference = end.difference(start);
    if (difference.inHours >= 1) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inMinutes}m';
    }
  }

  Future<void> deleteSlot(Slot slot) async {
    setState(() {
      isDeleting = true;
    });
    final profileStore = Provider.of<MyProfileStore>(context, listen: false);
    try {
      await UserService.deleteSlot(slot);
      final slotsData = await UserService.fetchSlots();
      profileStore.setSlots(slotsData);
    } catch (e) {
      showErrorDialog(e.toString());
    }
    if (!mounted) return;
    setState(() {
      isDeleting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: widget.slot.isBooked
            ? Border.all(color: context.myTheme.fail, width: 2)
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '${DateFormat('h:mm a').format(widget.slot.beginAt ?? DateTime.now())} - ${DateFormat('h:mm a').format(widget.slot.endAt ?? DateTime.now())}',
                    style: !widget.slot.isBooked
                        ? Theme.of(context).textTheme.headlineMedium
                        : Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(color: context.myTheme.fail),
                  ),
                  if (widget.slot.isBooked)
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TimeAgoWidget(dateTime: widget.slot.beginAt!),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Row(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      IconTextSlot(
                          svgPath: 'assets/icons/clock.svg',
                          text: widget.slot.beginAt != null &&
                                  widget.slot.endAt != null
                              ? getTimeDifference(
                                  widget.slot.beginAt!, widget.slot.endAt!)
                              : ''),
                      const SizedBox(width: 20),
                      IconTextSlot(
                          svgPath: 'assets/icons/calendar_sm.svg',
                          text: DateFormat('d MMM')
                              .format(widget.slot.beginAt ?? DateTime.now())),
                    ]),
                    if (widget.slot.isBooked &&
                        widget.slot.bookedBy.isNotEmpty) ...[
                      if (widget.slot.projectName != null) ...[
                        const SizedBox(height: 10),
                        IconTextSlot(
                            svgPath: 'assets/icons/clipboard.svg',
                            text: widget.slot.projectName!),
                      ],
                      const SizedBox(height: 10),
                      IconTextSlot(
                          svgPath: widget.slot.bookedBy.length > 1
                              ? 'assets/icons/people.svg'
                              : 'assets/icons/person_sm.svg',
                          text: widget.slot.bookedBy.join()),
                    ]
                  ],
                ),
              ]),
            ],
          ),
          !isDeleting
              ? GestureDetector(
                  onTap: () {
                    deleteSlot(widget.slot);
                  },
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: Align(
                      child: SvgPicture.asset('assets/icons/x.svg',
                          colorFilter: ColorFilter.mode(
                            !widget.slot.isBooked
                                ? context.myTheme.greyMain
                                : context.myTheme.fail,
                            BlendMode.srcIn,
                          )),
                    ),
                  ),
                )
              : SizedBox(
                  width: 20,
                  height: 20,
                  child: LoadingIndicator(
                    indicatorType: Indicator.lineSpinFadeLoader,
                    colors: [context.myTheme.greyMain],
                  ),
                ),
        ],
      ),
    );
  }
}
