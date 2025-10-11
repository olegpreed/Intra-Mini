import 'package:flutter/material.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class SalaryTag extends StatelessWidget {
  const SalaryTag({super.key, required this.salary});
  final String salary;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      // decoration: BoxDecoration(
      //   color: context.myTheme.success.withAlpha(30),
      //   borderRadius: BorderRadius.circular(100),
      // ),
      child: Text(
        salary,
        textAlign: TextAlign.right,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.myTheme.success,
            ),
      ),
    );
  }
}
