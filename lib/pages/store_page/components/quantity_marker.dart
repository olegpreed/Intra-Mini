import 'package:flutter/material.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class QuantityMarker extends StatelessWidget {
  const QuantityMarker({super.key, required this.quantity});

  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: context.myTheme.intra,
        border: Border.all(color: Colors.black, width: 2),
        shape: BoxShape.circle,
      ),
      child: Text(
        quantity.toString(),
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }
}
