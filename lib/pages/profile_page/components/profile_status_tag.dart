import 'package:flutter/material.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';

class ProfileStatusTag extends StatelessWidget {
  const ProfileStatusTag({super.key, required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    Color color =
        status == 'inactive' ? context.myTheme.fail : context.myTheme.intra;
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: Layout.padding / 3, vertical: Layout.padding / 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.4),
          borderRadius: BorderRadius.circular(Layout.cellWidth / 15),
        ),
        child: Text(status,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: color)));
  }
}
