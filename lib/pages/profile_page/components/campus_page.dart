import 'package:flutter/material.dart';
import 'package:forty_two_planet/data/country_flags.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class CampusPage extends StatelessWidget {
  const CampusPage({super.key, required this.campusData});
  final Campus campusData;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opacity(
                  opacity: 0.5,
                  child: Text('campus',
                      style: Theme.of(context).textTheme.bodyMedium)),
              Text(
                  '${campusData.name ?? ''} ${countryFlags[campusData.country ?? ''] ?? ''}',
                  style: Theme.of(context).textTheme.headlineMedium),
            ],
          ),
          Opacity(
            opacity: 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(campusData.city ?? '',
                    style: Theme.of(context).textTheme.bodyMedium),
                Text(campusData.country ?? '',
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          )
        ],
      ),
    ]);
  }
}
