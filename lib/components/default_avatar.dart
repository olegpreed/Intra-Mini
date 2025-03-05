import 'package:flutter/material.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class DefaultAvatar extends StatelessWidget {
  const DefaultAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        width: double.infinity,
        color: Theme.of(context).cardColor,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              height: double.infinity,
              width: double.infinity,
              child: FractionallySizedBox(
                widthFactor: 1,
                heightFactor: 0.28,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: context.myTheme.greySecondary,
                      borderRadius: BorderRadius.circular(50)),
                ),
              ),
            ),
            Center(
                child: FractionallySizedBox(
              widthFactor: 0.48,
              heightFactor: 0.48,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).cardColor,
                        width: 5,
                        strokeAlign: BorderSide.strokeAlignOutside),
                    color: context.myTheme.greySecondary,
                    borderRadius: BorderRadius.circular(50)),
              ),
            )),
          ],
        ));
  }
}
