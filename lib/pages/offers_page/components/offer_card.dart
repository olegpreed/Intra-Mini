import 'package:flutter/material.dart';
import 'package:forty_two_planet/pages/offer_detailed_page/offer_detailed_page.dart';
import 'package:forty_two_planet/pages/offers_page/components/salary_tag.dart';
import 'package:forty_two_planet/services/campus_data_service.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:translator/translator.dart';

class OfferCard extends StatelessWidget {
  const OfferCard({super.key, required this.offer, required this.translator});
  final JobOffer offer;
  final GoogleTranslator translator;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
         Navigator.push(context, MaterialPageRoute(builder: ((context) {
              return OfferDetailedPage(
                offer: offer,
                translator: translator,
              );
            })));
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: Layout.padding, vertical: Layout.gutter),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              offer.title ?? 'No title',
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: Layout.gutter),
            SalaryTag(salary: offer.salary ?? 'N/A'),
            SizedBox(height: Layout.gutter),
            Text(
              offer.location ?? 'No location',
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.myTheme.greyMain,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
