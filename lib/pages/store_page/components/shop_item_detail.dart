import 'package:flutter/material.dart';
import 'package:forty_two_planet/pages/store_page/components/item_counter.dart';
import 'package:forty_two_planet/services/campus_data_service.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';

class ShopItemDetail extends StatelessWidget {
  const ShopItemDetail(
      {super.key, required this.shopItem, required this.onChanged});
  final void Function(int) onChanged;
  final ShopItem shopItem;

  @override
  Widget build(BuildContext context) {
    double extraMargin = MediaQuery.of(context).padding.bottom == 0
        ? MediaQuery.of(context).size.height * 0.01
        : 0;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
          top: Layout.padding,
          left: Layout.padding,
          right: Layout.padding,
          bottom: 80 + extraMargin),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(shopItem.name ?? 'Unknown item',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: Theme.of(context).primaryColor)),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Text(shopItem.description ?? 'No description available',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Theme.of(context).primaryColor)),
              ),
            ),
            ItemCounter(count: shopItem.quantity, onChanged: onChanged)
          ],
        ),
      ),
    );
  }
}
