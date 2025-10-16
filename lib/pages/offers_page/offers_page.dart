import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:forty_two_planet/components/generic_header.dart';
import 'package:forty_two_planet/pages/offers_page/components/offer_card.dart';
import 'package:forty_two_planet/services/campus_data_service.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:translator/translator.dart';

class OffersPage extends StatefulWidget {
  const OffersPage({super.key, required this.campusId});
  final int campusId;

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  List<JobOffer> offers = [];
  bool isLoading = true;
  GoogleTranslator translator = GoogleTranslator();

  @override
  void initState() {
    super.initState();
    _fetchJobOffers();
  }

  Future<void> _fetchJobOffers() async {
    try {
      final fetchedOffers =
          await CampusDataService.fetchJobOffers(widget.campusId);
      if (!mounted) return;
      setState(() {
        offers = fetchedOffers;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
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
            const GenericHeader(title: 'Offers 💼'),
            SizedBox(height: Layout.gutter),
            Expanded(
                child: isLoading
                    ? Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: LoadingIndicator(
                            indicatorType: Indicator.lineSpinFadeLoader,
                            colors: [context.myTheme.greyMain],
                          ),
                        ),
                      )
                    : FadeIn(
                        child: offers.isEmpty
                            ? const Center(child: Text('No offers available'))
                            : ListView.builder(
                                itemCount: offers.length,
                                itemBuilder: (context, index) {
                                  final offer = offers[index];
                                  return OfferCard(
                                      offer: offer, translator: translator);
                                },
                              ),
                      ))
          ]),
        ),
      ),
    );
  }
}
