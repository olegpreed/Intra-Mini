import 'package:flutter/material.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:intl/intl.dart';

class LogColumnHint extends StatelessWidget {
  const LogColumnHint(
      {super.key,
      required this.startDate,
      required this.endDate,
      required this.logtime,
      required this.child});
  final DateTime startDate;
  final DateTime endDate;
  final double logtime;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      preferBelow: false,
      verticalOffset: 50,
      decoration: BoxDecoration(
        color: context.myTheme.greySecondary,
        borderRadius: BorderRadius.circular(10),
      ),
      triggerMode: TooltipTriggerMode.tap,
      textAlign: TextAlign.center,
      showDuration: const Duration(minutes: 1),
      richMessage: TextSpan(
        children: [
          TextSpan(
            text:
                '${DateFormat('d MMM').format(startDate)} - ${DateFormat('d MMM').format(endDate)}\n',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
          ),
          TextSpan(
            text: '${logtime.toStringAsFixed(1)}h',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
      child: child,
    );
  }
}
