import 'package:flutter/material.dart';
import 'package:forty_two_planet/pages/store_page/components/icon_points.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';

class StoreKart extends StatelessWidget {
  const StoreKart(
      {super.key, required this.walletPoints, required this.spentPoints});
  final int walletPoints;
  final int spentPoints;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Layout.padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconPoints(
                  points: walletPoints, svgPath: 'assets/icons/wallet.svg'),
              const SizedBox(width: 20),
              IconPoints(points: spentPoints, svgPath: 'assets/icons/kart.svg'),
            ],
          ),
          IconPoints(
              points: walletPoints - spentPoints,
              svgPath: 'assets/icons/resultArrow.svg'),
        ],
      ),
    );
  }
}
