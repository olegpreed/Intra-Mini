import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forty_two_planet/pages/calendar_page/components/create_slot_button.dart';
import 'package:forty_two_planet/pages/calendar_page/components/duration_slider.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/date_utils.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:intl/intl.dart';

enum SlotState { notTaken, beginning, middle, end }

class TimeSlotPicker extends StatefulWidget {
  const TimeSlotPicker({
    super.key,
    required this.slots,
    required this.selectedDay,
    required this.onSlotSelected,
  });
  final List<Slot> slots;
  final DateTime selectedDay;
  final Future<void> Function(DateTime, DateTime) onSlotSelected;

  DateTime get startTime =>
      roundUpTo15Minutes(selectedDay.day == DateTime.now().day
          ? DateTime.now().add(const Duration(minutes: 30))
          : DateTime(
              selectedDay.year,
              selectedDay.month,
              selectedDay.day,
              0,
              0,
              0,
              0,
              0,
            ));
  DateTime get endTime => startTime
      .add(const Duration(days: 1))
      .copyWith(hour: 6, minute: 0, second: 0, millisecond: 0, microsecond: 0);

  @override
  State<TimeSlotPicker> createState() => _TimeSlotPickerState();
}

class _TimeSlotPickerState extends State<TimeSlotPicker> {
  late double timeDivisionWidth;
  late double timeDivisionHeight;
  int minDivisionsOnScreen = 6 * 4;
  bool isLoading = false;
  late DateTime slotStartTime;
  late DateTime slotEndTime;
  late ScrollController _scrollController;
  int slotIntLength = 4;
  int maxSlotIntLength = 6 * 4;
  int maxPossibleSlotIntLength = 6 * 4;
  double leftPadding = 20;
  double sliderValue = 1;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    slotStartTime = widget.startTime;
    slotEndTime = widget.startTime.add(const Duration(minutes: 15));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.of(context).size;
    timeDivisionWidth = (size.width - leftPadding) / (minDivisionsOnScreen);
    timeDivisionHeight = (size.height -
            MediaQuery.of(context).padding.top -
            MediaQuery.of(context).padding.bottom) *
        0.06;
  }

  void onDurationSliderChange(double value) {
    HapticFeedback.selectionClick();
    setState(() {
      sliderValue = value;
      slotIntLength = value.round();
      slotEndTime = slotStartTime.add(Duration(minutes: 15 * value.round()));
    });
  }

  void createSlot() async {
    setState(() {
      isLoading = true;
    });
    await widget.onSlotSelected(slotStartTime, slotEndTime);
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  List<Widget> generateTimeDivisions(
      List<Slot> slots, double screenWidth, double screenHeight) {
    List<Widget> timeDivisions = [];
    DateTime currentTime = widget.startTime;
    while (currentTime.isBefore(widget.endTime)) {
      bool booked = false;
      SlotState slotState = SlotState.notTaken;

      for (var slot in slots) {
        slotState = getSlotState(slot, currentTime);
        if (slotState != SlotState.notTaken) {
          if (slot.isBooked) {
            booked = true;
          }
          break;
        }
      }
      BorderRadius borderRadius;
      switch (slotState) {
        case SlotState.beginning:
          borderRadius = const BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          );
          break;
        case SlotState.middle:
          borderRadius = BorderRadius.zero;
          break;
        case SlotState.end:
          borderRadius = const BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          );
          break;
        default:
          borderRadius = BorderRadius.circular(10);
      }
      bool isHourStart = currentTime.minute == 0;
      timeDivisions.add(SizedBox(
        height: screenHeight * 0.1,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: AlignmentDirectional.topCenter,
          children: [
            Visibility(
              visible: isHourStart,
              child: Positioned(
                bottom: 0,
                left: 0,
                child: Text(
                  DateFormat('ha').format(currentTime).toLowerCase(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: context.myTheme.greyMain),
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeIn,
              width: timeDivisionWidth,
              height: timeDivisionHeight,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: SlotState.notTaken != slotState
                    ? (booked
                        ? context.myTheme.fail.withOpacity(0.6)
                        : context.myTheme.intra.withOpacity(0.5))
                    : null,
              ),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      height: isHourStart
                          ? timeDivisionHeight - Layout.padding / 2
                          : timeDivisionHeight - Layout.padding,
                      width: 2,
                      color: isHourStart
                          ? context.myTheme.greyMain
                          : Theme.of(context).cardColor)),
            ),
          ],
        ),
      ));
      currentTime = currentTime.add(const Duration(minutes: 15));
    }
    return timeDivisions;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                left: Layout.padding, right: Layout.padding, top: 30),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('From',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(color: context.myTheme.greySecondary)),
                    Text('To',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(color: context.myTheme.greySecondary)),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.008,
                ),
                Stack(alignment: AlignmentDirectional.center, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          maxLines: 1,
                          DateFormat('h:mm a').format(slotStartTime),
                          style: Theme.of(context).textTheme.headlineMedium),
                      Expanded(
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).cardColor,
                                context.myTheme.greySecondary,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                context.myTheme.greySecondary,
                                Theme.of(context).cardColor,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                      ),
                      Text(
                          maxLines: 1,
                          DateFormat('h:mm a').format(slotEndTime),
                          style: Theme.of(context).textTheme.headlineMedium),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    color: Theme.of(context).cardColor,
                    child: Text(formatMinutes(slotIntLength * 15),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: context.myTheme.greySecondary,
                            )),
                  ),
                ]),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
              ],
            ),
          ),
        ),
        Column(
          children: [
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
              child: Stack(alignment: AlignmentDirectional.topStart, children: [
                NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollEndNotification) {
                      setState(() {
                        double targetPosition =
                            (_scrollController.offset / timeDivisionWidth)
                                    .round() *
                                timeDivisionWidth;
                        if (targetPosition >=
                            (widget.endTime
                                            .difference(widget.startTime)
                                            .inMinutes ~/
                                        15) *
                                    timeDivisionWidth -
                                timeDivisionWidth * 2) {
                          targetPosition = (widget.endTime
                                          .difference(widget.startTime)
                                          .inMinutes ~/
                                      15) *
                                  timeDivisionWidth -
                              timeDivisionWidth * 3;
                        }
                        slotStartTime = widget.startTime.add(Duration(
                            minutes:
                                15 * (targetPosition ~/ timeDivisionWidth)));
                        int endStartDifference = widget.endTime
                                    .difference(slotStartTime)
                                    .inMinutes ~/
                                15 +
                            1;
                        slotEndTime = slotStartTime
                            .add(Duration(minutes: 15 * slotIntLength));
                        maxPossibleSlotIntLength =
                            endStartDifference > maxSlotIntLength
                                ? maxSlotIntLength
                                : endStartDifference;
                        slotIntLength = slotIntLength > maxPossibleSlotIntLength
                            ? maxPossibleSlotIntLength
                            : slotIntLength;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _scrollController.animateTo(
                            targetPosition,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        });
                      });
                    }
                    return true;
                  },
                  child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 350),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: generateTimeDivisions(
                              widget.slots, screenWidth, screenHeight),
                        ),
                      )),
                ),
                IgnorePointer(
                  child: AnimatedContainer(
                    margin: const EdgeInsets.only(left: 20),
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeInOut,
                    height: timeDivisionHeight,
                    width: slotIntLength * timeDivisionWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: context.myTheme.intra.withOpacity(0.5),
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Stack(alignment: AlignmentDirectional.topCenter, children: [
                  DurationSlider(
                    slotIntLength: slotIntLength,
                    maxPossibleSlotIntLength: maxPossibleSlotIntLength,
                    onChange: onDurationSliderChange,
                  ),
                  IgnorePointer(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Column(
                        children: [
                          Text('Duration',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: context.myTheme.greyMain)),
                          // Text('offset value: ${_scrollController.offset}'),
                        ],
                      ),
                    ),
                  ),
                ]),
                Expanded(
                  child: CreateSlotButton(
                    onPressed: createSlot,
                    isLoading: isLoading,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
