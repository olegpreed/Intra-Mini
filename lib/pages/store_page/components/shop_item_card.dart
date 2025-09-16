import 'package:flutter/material.dart';
import 'package:forty_two_planet/pages/store_page/components/price_tag.dart';
import 'package:forty_two_planet/services/campus_data_service.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';

class ShopItemCard extends StatelessWidget {
  const ShopItemCard({super.key, required this.shopItem});
  final ShopItem shopItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: Layout.cellWidth,
          width: double.infinity,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.network(
            shopItem.imageUrl ?? '',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(shopItem.name ?? 'Unkown item',
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                  softWrap: true,
                  style: Theme.of(context).textTheme.bodyMedium),
              PriceTag(price: shopItem.price),
            ],
          ),
        ),
      ],
    );
  }
}
