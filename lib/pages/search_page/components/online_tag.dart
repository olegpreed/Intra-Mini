import 'package:flutter/material.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class OnlineTag extends StatelessWidget {
  const OnlineTag({super.key, this.location});
  final String? location;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
          color: context.myTheme.success.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text('$location',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: context.myTheme.success)),
      ),
    );
  }
}
