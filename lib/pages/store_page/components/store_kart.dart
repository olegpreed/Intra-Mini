import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreKart extends StatelessWidget {
  const StoreKart(
      {super.key,
      required this.walletPoints,
      required this.spentPoints,
      required this.onRevert});
  final int walletPoints;
  final int spentPoints;
  final VoidCallback onRevert;

  @override
  Widget build(BuildContext context) {
    int resultPoints = walletPoints - spentPoints;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Layout.padding / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                  '${(resultPoints).toString()} ${Platform.isAndroid ? "₩" : "₳"}',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: resultPoints >= 0
                          ? context.myTheme.success
                          : context.myTheme.fail)),
              if (spentPoints > 0) ...[
                GestureDetector(
                  onTap: onRevert,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: SvgPicture.asset(
                      'assets/icons/revert.svg',
                      colorFilter: ColorFilter.mode(
                        context.myTheme.greyMain,
                        BlendMode.srcIn,
                      ),
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ],
            ],
          ),
          GestureDetector(
            onTap: () async {
              final Uri url = Uri.parse('https://shop.intra.42.fr/');
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.inAppBrowserView);
              } else {
                return;
              }
            },
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                decoration: BoxDecoration(
                  color: context.myTheme.intra.withAlpha(50),
                  borderRadius: const BorderRadius.all(Radius.circular(200)),
                ),
                child: Text('Buy',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: context.myTheme.intra))),
          ),
        ],
      ),
    );
  }
}
