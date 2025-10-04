import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
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
      child: FlutterSlider(
          handlerAnimation: const FlutterSliderHandlerAnimation(
            scale: 1.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            color: Theme.of(context).cardColor,
            border: Border.all(
                color: Theme.of(context).scaffoldBackgroundColor, width: 2),
          ),
          jump: true,
          handlerHeight: 30,
          handlerWidth: 40,
          tooltip: FlutterSliderTooltip(
            custom: (value) => Container(
              height: 40,
              width: 40,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  value.toString().substring(0, value.toString().indexOf('.')),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                ),
              ),
            ),
          ),
          trackBar: FlutterSliderTrackBar(
            inactiveTrackBar: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            activeTrackBar: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
          ),
          rightHandler: FlutterSliderHandler(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Theme.of(context).cardColor,
                  Theme.of(context).cardColor.withAlpha(0),
                ],
                center: Alignment.center,
                radius: 1,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                widget.levelValues.end.toInt().toString(),
                style: TextStyle(
                  color: context.myTheme.greyMain,
                ),
              ),
            ),
          ),
          handler: FlutterSliderHandler(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Theme.of(context).cardColor,
                  Theme.of(context).cardColor.withAlpha(0),
                ],
                center: Alignment.center,
                radius: 1,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                widget.levelValues.start.toInt().toString(),
                style: TextStyle(
                  color: context.myTheme.greyMain,
                ),
              ),
            ),
          ),
          rangeSlider: true,
          values: [widget.levelValues.start, widget.levelValues.end],
          max: 21,
          min: 0,
          onDragging: (handlerIndex, lowerValue, upperValue) {
            widget.changeLevelRange(RangeValues(lowerValue, upperValue));
          }),
    );
  }
}
