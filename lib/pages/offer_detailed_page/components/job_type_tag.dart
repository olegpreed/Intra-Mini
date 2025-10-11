import 'package:flutter/material.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class JobTypeTag extends StatelessWidget {
  const JobTypeTag({super.key, required this.jobType});
  final String jobType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      decoration: BoxDecoration(
        color: context.myTheme.greySecondary,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(jobType, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
