import 'package:flutter/material.dart';
import 'package:forty_two_planet/utils/date_utils.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';

class ProfileOnlineStatus extends StatelessWidget {
  const ProfileOnlineStatus(
      {super.key, required this.lastSeen, required this.location});
  final DateTime? lastSeen;
  final String? location;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
            location ??
                (lastSeen == null
                    ? ''
                    : '${timeAgoShort(
                        lastSeen!,
                      )} ago'),
            style: location == null
                ? Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: context.myTheme.greySecondary)
                : Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(color: context.myTheme.greyMain)),
        SizedBox(width: Layout.gutter),
        if (location != null)
          Container(
            width: Layout.cellWidth / 6,
            height: Layout.cellWidth / 6,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: context.myTheme.online),
          ),
      ],
    );
  }
}
