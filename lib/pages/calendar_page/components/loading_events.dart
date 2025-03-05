import 'package:flutter/material.dart';
import 'package:forty_two_planet/components/shimmer.dart';
import 'package:forty_two_planet/components/shimmer_loading.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class LoadingEvents extends StatelessWidget {
  const LoadingEvents({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      linearGradient: shimmerGradient([
        Theme.of(context).cardColor,
        context.myTheme.shimmer,
        Theme.of(context).cardColor,
      ]),
      child: ShimmerLoading(
        isLoading: true,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.width * 0.18 + 14,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              height: MediaQuery.of(context).size.width * 0.18 + 14,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
