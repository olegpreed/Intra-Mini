import 'package:flutter/material.dart';
import 'package:forty_two_planet/main.dart';
import 'package:forty_two_planet/pages/calendar_page/components/time_slot_picker.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class SlidingGradientTransform extends GradientTransform {
  const SlidingGradientTransform({
    required this.slidePercent,
  });

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(
        bounds.width * slidePercent, bounds.height * slidePercent, 0.0);
  }
}

LinearGradient shimmerGradient(List<Color> colors) {
  return LinearGradient(
    colors: colors,
    stops: const [
      0.2,
      0.4,
      0.6,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    tileMode: TileMode.clamp,
  );
}

class Layout {
  static late double padding;
  static late double gutter;
  static late double cellWidth;
  static late double screenWidth;
  static late double screenHeight;
  static late double bigBtnHeight;
  static late bool hasScreenBuffers;

  static void initialize(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    hasScreenBuffers = MediaQuery.of(context).padding.bottom != 0;
    padding = screenWidth * 0.05;
    gutter = screenWidth * 0.02;
    bigBtnHeight = screenWidth * 0.2;
    cellWidth = (screenWidth - padding * 2 - gutter * 2) / 3;
  }
}

Future<void> showErrorDialog(String error) async {
  await showDialog(
    context: navigatorKey.currentContext!,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: context.myTheme.greyMain,
        title: const Text('Error'),
        content: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical, child: Text(error))),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Ok"),
          ),
        ],
      );
    },
  );
}

SlotState getSlotState(Slot slot, DateTime currentTime) {
  DateTime fifteenMinutesLater = currentTime.add(const Duration(minutes: 15));
  bool isBeginning = slot.beginAt!.day == currentTime.day &&
      slot.beginAt!.hour == currentTime.hour &&
      slot.beginAt!.minute == currentTime.minute;
  bool isMiddle =
      currentTime.isAfter(slot.beginAt!) && currentTime.isBefore(slot.endAt!);
  bool isEnd = slot.endAt!.day == fifteenMinutesLater.day &&
      slot.endAt!.hour == fifteenMinutesLater.hour &&
      slot.endAt!.minute == fifteenMinutesLater.minute;
  if (isBeginning) {
    return SlotState.beginning;
  } else if (isEnd) {
    return SlotState.end;
  } else if (isMiddle) {
    return SlotState.middle;
  } else {
    return SlotState.notTaken;
  }
}
