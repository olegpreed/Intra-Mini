import 'package:flutter/material.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class PriceTag extends StatelessWidget {
  const PriceTag({super.key, required this.price, required this.isAffordable});
  final int? price;
  final bool isAffordable;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      alignment: Alignment.bottomCenter,
      duration: const Duration(milliseconds: 300),
      child: price != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isAffordable
                    ? context.myTheme.success.withAlpha(30)
                    : context.myTheme.fail.withAlpha(30),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$price ₳',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isAffordable
                        ? context.myTheme.success
                        : context.myTheme.fail),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
