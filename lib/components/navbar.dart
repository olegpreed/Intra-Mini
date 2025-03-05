import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';

class MyNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  MyNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  final iconSvgPaths = [
    'assets/icons/profile.svg',
    'assets/icons/search.svg',
    'assets/icons/calendar.svg',
  ];

  @override
  Widget build(BuildContext context) {
    Color activeColor = Theme.of(context).primaryColor;
    Color inactiveColor = context.myTheme.greySecondary;
    return SafeArea(
      child: Container(
        height: 70,
        width: 176,
        margin: EdgeInsets.only(
            bottom: !Layout.hasScreenBuffers ? Layout.screenHeight * 0.01 : 0),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(
              color: context.myTheme.greySecondary,
              width: 2,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(60),
            )),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            iconSvgPaths.length,
            (index) => _buildNavBarItem(
              index,
              iconSvgPaths[index],
              activeColor,
              inactiveColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavBarItem(
      int index, String svgPath, Color activeColor, Color inactiveColor) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onItemTapped(index);
        },
        behavior: HitTestBehavior.translucent,
        child: SizedBox(
          height: double.infinity,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 130),
            child: SvgPicture.asset(svgPath,
                key: ValueKey(index == selectedIndex),
                fit: BoxFit.none,
                colorFilter: ColorFilter.mode(
                    index == selectedIndex ? activeColor : inactiveColor,
                    BlendMode.srcIn)),
          ),
        ),
      ),
    );
  }
}
