import 'package:flutter/material.dart';
import 'package:forty_two_planet/data/country_flags.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:url_launcher/url_launcher.dart';

class CampusPage extends StatelessWidget {
  const CampusPage({super.key, required this.campusData});
  final Campus campusData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (campusData.website == null) return;
        launchUrl(Uri.parse(campusData.website!),
            mode: LaunchMode.inAppBrowserView);
      },
      child: Stack(children: [
        Padding(
          padding: EdgeInsets.only(right: Layout.gutter),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Opacity(
                        opacity: 0.3,
                        child: Text('campus',
                            style: Theme.of(context).textTheme.bodyMedium)),
                    Text(
                        '${campusData.name ?? ''} ${countryFlags[campusData.country ?? ''] ?? ''}',
                        style: Theme.of(context).textTheme.headlineMedium),
                  ],
                ),
              ),
              Expanded(
                child: Opacity(
                  opacity: 0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(campusData.city ?? '',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(campusData.country ?? '',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
