import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';

class CircularProgress extends StatelessWidget {
  CircularProgress({super.key, required this.level, this.color});
  final double level;
  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);
  final Color? color;

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    return DashedCircularProgressBar.aspectRatio(
      aspectRatio: 1,
      valueNotifier: _valueNotifier,
      progress: (level - level.truncate()) * 100,
      startAngle: 0,
      sweepAngle: 360,
      foregroundColor: color!,
      backgroundColor: backgroundColor,
      foregroundStrokeWidth: Layout.cellWidth * 0.09,
      backgroundStrokeWidth: Layout.cellWidth * 0.09,
      animation: false,
      animationDuration: const Duration(milliseconds: 500),
      animationCurve: Curves.easeInOut,
      foregroundGapSize: 5,
      foregroundDashSize: 5,
      backgroundGapSize: 5,
      backgroundDashSize: 5,
      corners: StrokeCap.butt,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          level.toString(),
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
    );
  }
}
