import 'package:flutter/material.dart';
import 'package:forty_two_planet/services/campus_data_service.dart';

class ShopItemDetail extends StatelessWidget {
  const ShopItemDetail(
      {super.key, required this.shopItem, required this.onAdded});
  final void Function(int) onAdded;
  final ShopItem shopItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(shopItem.name ?? 'Unknown item',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(shopItem.description ?? 'No description available',
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
