import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:forty_two_planet/pages/store_page/components/price_tag.dart';
import 'package:forty_two_planet/pages/store_page/components/quantity_marker.dart';
import 'package:forty_two_planet/services/campus_data_service.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';

class ShopItemCard extends StatelessWidget {
  const ShopItemCard(
      {super.key,
      required this.shopItem,
      required this.isAffordable,
      required this.isLoading});
  final ShopItem? shopItem;
  final bool isLoading;
  final bool isAffordable;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState:
              isLoading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: Container(
            width: double.infinity,
            height: Layout.cellWidth,
            decoration: BoxDecoration(
              color: context.myTheme.greySecondary,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          secondChild: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                foregroundDecoration: BoxDecoration(
                  color: shopItem != null && shopItem!.quantity > 0
                      ? context.myTheme.intra.withAlpha(100)
                      : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                height: Layout.cellWidth,
                width: double.infinity,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: context.myTheme.greySecondary,
                ),
                child: shopItem != null
                    ? CachedNetworkImage(
                        imageUrl: shopItem?.imageUrl ?? '',
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(milliseconds: 300),
                        placeholder: (context, url) => Container(
                          color: context.myTheme.greySecondary,
                        ),
                        errorWidget: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image),
                      )
                    : const SizedBox.shrink(),
              ),
              if (shopItem?.quantity != null && shopItem!.quantity > 0)
                QuantityMarker(quantity: shopItem?.quantity ?? 0)
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(shopItem?.name ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                  softWrap: true,
                  style: Theme.of(context).textTheme.bodyMedium),
              PriceTag(price: shopItem?.price, isAffordable: isAffordable),
            ],
          ),
        ),
      ],
    );
  }
}
