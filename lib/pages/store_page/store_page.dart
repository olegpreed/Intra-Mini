import 'package:flutter/material.dart';
import 'package:forty_two_planet/pages/store_page/components/shop_item_card.dart';
import 'package:forty_two_planet/pages/store_page/components/shop_item_detail.dart';
import 'package:forty_two_planet/components/generic_header.dart';
import 'package:forty_two_planet/pages/store_page/components/store_kart.dart';
import 'package:forty_two_planet/services/campus_data_service.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';

class StorePage extends StatefulWidget {
  const StorePage(
      {super.key, required this.walletPoints, required this.campusId});
  final int walletPoints;
  final int? campusId;

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  int spentPoints = 0;
  bool isLoading = true;
  List<ShopItem> shopItems = [];

  @override
  void initState() {
    super.initState();
    _fetchStoreData();
  }

  void _fetchStoreData() async {
    if (widget.campusId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showErrorDialog('Campus ID is null');
      });
      return;
    }
    shopItems = await CampusDataService.fetchShopItems(widget.campusId!);
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Layout.padding),
          child: Column(children: [
            const GenericHeader(title: 'Intra shop'),
            StoreKart(
              walletPoints: widget.walletPoints,
              spentPoints: spentPoints,
              onRevert: () {
                setState(() {
                  spentPoints = 0;
                  for (var item in shopItems) {
                    item.quantity = 0;
                  }
                });
              },
            ),
            Expanded(
              child: GridView.builder(
                  padding: EdgeInsets.only(bottom: 200),
                  itemCount: isLoading ? 10 : shopItems.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.85,
                      mainAxisSpacing: Layout.gutter * 2,
                      crossAxisSpacing: Layout.gutter,
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (isLoading) return;
                        showModalBottomSheet(
                            backgroundColor: context.myTheme.greySecondary,
                            context: context,
                            builder: (context) {
                              return ShopItemDetail(
                                  shopItem: shopItems[index],
                                  onChanged: (int quantity) {
                                    shopItems[index].quantity = quantity;
                                    setState(() {
                                      spentPoints = shopItems.fold(
                                          0,
                                          (sum, item) =>
                                              sum +
                                              (item.quantity *
                                                  (item.price ?? 0)));
                                    });
                                  });
                            });
                      },
                      child: ShopItemCard(
                          isAffordable: shopItems.isEmpty
                              ? true
                              : widget.walletPoints -
                                      spentPoints -
                                      (shopItems[index].price ?? 0) >
                                  0,
                          shopItem: shopItems.isEmpty ? null : shopItems[index],
                          isLoading: isLoading),
                    );
                  }),
            )
          ]),
        ),
      ),
    );
  }
}
