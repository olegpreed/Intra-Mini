import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CreateSlotButton extends StatelessWidget {
  const CreateSlotButton(
      {super.key, required this.onPressed, required this.isLoading});
  final void Function() onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    double extraMargin = MediaQuery.of(context).padding.bottom == 0
        ? MediaQuery.of(context).size.height * 0.01
        : 0;
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.only(bottom: 80 + extraMargin),
          height: 70,
          width: 176,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              side: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
              foregroundColor: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              if (!isLoading) {
                HapticFeedback.lightImpact();
                onPressed();
              }
            },
            child: isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: LoadingIndicator(
                      indicatorType: Indicator.lineSpinFadeLoader,
                      colors: [Theme.of(context).primaryColor],
                    ),
                  )
                : const Text('Create'),
          ),
        ),
      ),
    );
  }
}
