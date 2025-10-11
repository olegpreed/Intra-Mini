import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forty_two_planet/components/pressable_scale.dart';
import 'package:loading_indicator/loading_indicator.dart';

class TranslateBtn extends StatelessWidget {
  const TranslateBtn({super.key, required this.onTap, required this.isLoading});
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    double extraMargin = MediaQuery.of(context).padding.bottom == 0
        ? MediaQuery.of(context).size.height * 0.01
        : 0;
    return SafeArea(
      child: PressableScale(
        onPressed: onTap,
        child: Container(
          margin: EdgeInsets.only(bottom: 80 + extraMargin),
          height: 72,
          width: 72,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor,
          ),
          child: isLoading
              ? Center(
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: LoadingIndicator(
                      indicatorType: Indicator.lineSpinFadeLoader,
                      colors: [Theme.of(context).scaffoldBackgroundColor],
                    ),
                  ),
                )
              : SvgPicture.asset('assets/icons/translate.svg',
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).scaffoldBackgroundColor,
                      BlendMode.srcIn),
                  fit: BoxFit.fitWidth),
        ),
      ),
    );
  }
}
