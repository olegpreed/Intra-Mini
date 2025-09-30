import 'package:flutter/material.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:loading_indicator/loading_indicator.dart';

class SubscribeBtn extends StatefulWidget {
  const SubscribeBtn(
      {super.key,
      required this.isExam,
      required this.isSubscribed,
      required this.onPressed,
      required this.isLoading});
  final bool isExam;
  final bool isSubscribed;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  State<SubscribeBtn> createState() => _SubscribeBtnState();
}

class _SubscribeBtnState extends State<SubscribeBtn> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      behavior: HitTestBehavior.translucent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 30,
        constraints: BoxConstraints(
          minWidth:
              MediaQuery.of(context).size.width * 0.3, // Set minimum width
        ),
        decoration: BoxDecoration(
          color: widget.isSubscribed
              ? context.myTheme.fail.withOpacity(0.4)
              : context.myTheme.intra.withOpacity(0.4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Align(
          alignment: Alignment.center,
          child: widget.isLoading
              ? FractionallySizedBox(
                  heightFactor: 0.7,
                  child: LoadingIndicator(
                    indicatorType: Indicator.lineSpinFadeLoader,
                    colors: [
                      widget.isSubscribed
                          ? context.myTheme.fail
                          : context.myTheme.intra
                    ],
                  ),
                )
              : Text(widget.isSubscribed ? 'unsubscribe' : 'subscribe',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: widget.isSubscribed
                            ? context.myTheme.fail
                            : context.myTheme.intra,
                      )),
        ),
      ),
    );
  }
}
