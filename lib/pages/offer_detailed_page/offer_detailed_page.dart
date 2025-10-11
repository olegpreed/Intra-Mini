import 'package:flutter/material.dart';
import 'package:forty_two_planet/components/generic_header.dart';
import 'package:forty_two_planet/pages/offer_detailed_page/components/email_widget.dart';
import 'package:forty_two_planet/pages/offer_detailed_page/components/job_type_tag.dart';
import 'package:forty_two_planet/pages/offer_detailed_page/components/translate_btn.dart';
import 'package:forty_two_planet/services/campus_data_service.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/text_utils.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:translator/translator.dart';

class OfferDetailedPage extends StatefulWidget {
  const OfferDetailedPage(
      {super.key, required this.offer, required this.translator});
  final JobOffer offer;
  final GoogleTranslator translator;

  @override
  State<OfferDetailedPage> createState() => _OfferDetailedPageState();
}

class _OfferDetailedPageState extends State<OfferDetailedPage> {
  String translatedTitle = '';
  String translatedLittleDesc = '';
  String translatedBigDesc = '';
  String translatedSalary = '';
  bool isTranslated = false;
  bool isLoading = false;

  void _translatePage() async {
    if (isTranslated) {
      setState(() {
        isTranslated = false;
      });
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final titleTranslation = await widget.translator
          .translate(widget.offer.title ?? 'No title', to: 'en');
      final littleDescTranslation = await widget.translator.translate(
          widget.offer.littleDescription ?? 'No description',
          to: 'en');
      final bigDescTranslation = await widget.translator.translate(
          widget.offer.bigDescription ?? 'No detailed description',
          to: 'en');
      final salaryTranslation = await widget.translator
          .translate(widget.offer.salary ?? 'N/A', to: 'en');
      if (!mounted) return;
      setState(() {
        translatedTitle = titleTranslation.text;
        translatedLittleDesc = littleDescTranslation.text;
        translatedBigDesc = bigDescTranslation.text;
        translatedSalary = salaryTranslation.text;
        isTranslated = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isTranslated = false;
        isLoading = false;
      });
      await showErrorDialog('Translation failed: $e');
      return;
    }
    if (!mounted) return;
    setState(() {
      isLoading = false;
      isTranslated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Layout.padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GenericHeader(
                          title: isTranslated
                              ? translatedTitle
                              : widget.offer.title ?? 'No title'),
                      SizedBox(height: Layout.gutter),
                      Text(
                          isTranslated
                              ? translatedSalary
                              : widget.offer.salary ?? 'N/A',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: context.myTheme.success,
                              )),
                      SizedBox(height: Layout.gutter),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (widget.offer.contractType != null)
                            JobTypeTag(jobType: widget.offer.contractType!),
                          SizedBox(width: Layout.gutter),
                          if (widget.offer.email != null)
                            EmailWidget(email: widget.offer.email!),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Layout.gutter),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: Layout.padding),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding:
                            EdgeInsets.only(top: Layout.padding, bottom: 200),
                        child: Column(
                          children: [
                            Text(
                              isTranslated
                                  ? translatedLittleDesc
                                  : widget.offer.littleDescription ??
                                      'No description',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Divider(
                              height: Layout.gutter * 2,
                              thickness: 1,
                              color: context.myTheme.greyMain,
                            ),
                            SizedBox(height: Layout.gutter),
                            ClickableText(
                              text: isTranslated
                                  ? translatedBigDesc
                                  : widget.offer.bigDescription ??
                                      'No detailed description',
                              style: Theme.of(context).textTheme.bodySmall!,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            TranslateBtn(
              onTap: _translatePage,
              isLoading: isLoading,
            )
          ],
        ),
      ),
    );
  }
}
