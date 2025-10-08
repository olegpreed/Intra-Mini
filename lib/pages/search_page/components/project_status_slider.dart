import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class ProjectSliderStatus extends StatefulWidget {
  const ProjectSliderStatus(
      {super.key, required this.index, required this.onPressed});
  final Function(int) onPressed;
  final int index;

  @override
  State<ProjectSliderStatus> createState() => _ProjectSliderStatusState();
}

class _ProjectSliderStatusState extends State<ProjectSliderStatus> {
  int _slidingIndex = 0;

  final List<String> _iconPaths = [
    'assets/icons/unlocked.svg',
    'assets/icons/locked.svg',
    'assets/icons/finished.svg',
  ];

  @override
  Widget build(BuildContext context) {
    _slidingIndex = widget.index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 35,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: Theme.of(context).scaffoldBackgroundColor,
          width: 2,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(60),
        ),
      ),
      child: Row(
        children: List.generate(_iconPaths.length, (index) {
          final bool isSelected = _slidingIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                widget.onPressed(index);
                setState(() {
                  _slidingIndex = index;
                });
              },
              behavior: HitTestBehavior.translucent,
              child: Center(
                child: TweenAnimationBuilder<Color?>(
                  duration: const Duration(milliseconds: 100),
                  tween: ColorTween(
                    begin: context.myTheme.greyMain,
                    end: isSelected
                        ? Theme.of(context).primaryColor
                        : context.myTheme.greyMain,
                  ),
                  builder: (context, color, child) {
                    return SvgPicture.asset(
                      _iconPaths[index],
                      height: 18,
                      fit: BoxFit.contain,
                      colorFilter: ColorFilter.mode(color!, BlendMode.srcIn),
                    );
                  },
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
