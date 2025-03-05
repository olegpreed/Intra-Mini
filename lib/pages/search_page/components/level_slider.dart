import 'package:flutter/material.dart';
import 'package:forty_two_planet/extended_widgets/custom_slider_thumb.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class LevelSlider extends StatefulWidget {
  const LevelSlider(
      {super.key,
      required this.levelValues,
      required this.labels,
      required this.changeLevelRange});
  final RangeValues levelValues;
  final RangeLabels labels;
  final Function(RangeValues) changeLevelRange;

  @override
  State<LevelSlider> createState() => _LevelSliderState();
}

class _LevelSliderState extends State<LevelSlider> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: SliderTheme(
        data: SliderThemeData(
          overlayShape: SliderComponentShape.noOverlay,
          activeTrackColor: Colors.transparent,
          inactiveTrackColor: Colors.transparent,
          thumbColor: Theme.of(context).cardColor,
          valueIndicatorColor: context.myTheme.greySecondary,
          valueIndicatorTextStyle: Theme.of(context).textTheme.bodyMedium,
          trackHeight: 35,
          rangeTrackShape: CustomRangeSliderTrackShape(
              borderColor: Theme.of(context).scaffoldBackgroundColor),
          overlayColor: Colors.transparent,
          overlappingShapeStrokeColor: Colors.transparent,
          rangeValueIndicatorShape:
              const PaddleRangeSliderValueIndicatorShape(),
          rangeThumbShape: CustomRangeSliderThumbShape(
            thumbRadius: 18,
            rangeValues: widget.levelValues,
            myContext: context,
            isThumbPressed: isPressed,
            borderColor: Theme.of(context).scaffoldBackgroundColor,
            textColor: context.myTheme.greySecondary,
          ),
        ),
        child: RangeSlider(
          min: 0,
          max: 21,
          divisions: 21,
          values: widget.levelValues,
          labels: widget.labels,
          onChangeStart: (value) => setState(() => isPressed = true),
          onChangeEnd: (value) => setState(() => isPressed = false),
          onChanged: widget.changeLevelRange,
        ),
      ),
    );
  }
}
