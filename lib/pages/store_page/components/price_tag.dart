import 'package:flutter/material.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class PriceTag extends StatelessWidget {
  const PriceTag({super.key, required this.price});
  final int? price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: context.myTheme.intra.withAlpha(50),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$price ₳',
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: context.myTheme.intra),
      ),
    );
  }
}
