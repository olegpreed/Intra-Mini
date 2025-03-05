import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';

class LoginHeadlines extends StatelessWidget {
  LoginHeadlines({super.key});
  final List<String> _headlines = [
    'See who is on site',
    'Search cadets by project',
    'Track your progress',
    'Put evaluation slots',
    'Subscribe to events',
  ];

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Layout.padding),
        child: Center(
          child: AnimatedTextKit(
            repeatForever: true,
            animatedTexts: _headlines.map((message) {
              return TypewriterAnimatedText(
                speed: const Duration(milliseconds: 100),
                message,
                textAlign: TextAlign.center,
                textStyle: Theme.of(context).textTheme.displayLarge,
              );
            }).toList(),
            pause: const Duration(milliseconds: 0),
            displayFullTextOnTap: true,
            stopPauseOnTap: true,
          ),
        ),
      ),
    );
  }
}
