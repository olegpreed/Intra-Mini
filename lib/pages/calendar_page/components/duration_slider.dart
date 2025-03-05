import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class DurationSlider extends StatelessWidget {
  const DurationSlider(
      {super.key,
      required this.slotIntLength,
      required this.maxPossibleSlotIntLength,
      required this.onChange});
  final int slotIntLength;
  final int maxPossibleSlotIntLength;
  final void Function(double) onChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/reduce.svg',
            colorFilter: ColorFilter.mode(
                context.myTheme.greySecondary, BlendMode.srcIn),
          ),
          Flexible(
            child: SizedBox(
              width: 220,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: Theme.of(context).scaffoldBackgroundColor,
                    inactiveTrackColor:
                        Theme.of(context).scaffoldBackgroundColor,
                    thumbColor: context.myTheme.greySecondary,
                    valueIndicatorColor: Theme.of(context).cardColor,
                    valueIndicatorTextStyle:
                        Theme.of(context).textTheme.bodyMedium,
                    trackHeight: 10,
                    overlayColor: Colors.transparent,
                    activeTickMarkColor: Colors.transparent,
                    inactiveTickMarkColor: Colors.transparent,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 10,
                    ),
                  ),
                  child: Slider(
                      value: slotIntLength.toDouble(),
                      min: 1,
                      max: maxPossibleSlotIntLength.toDouble(),
                      divisions: maxPossibleSlotIntLength - 1 < 0
                          ? 1
                          : maxPossibleSlotIntLength - 1,
                      onChanged: onChange),
                ),
              ),
            ),
          ),
          SvgPicture.asset(
            'assets/icons/increase.svg',
            colorFilter: ColorFilter.mode(
                context.myTheme.greySecondary, BlendMode.srcIn),
          ),
        ],
      ),
    );
  }
}
