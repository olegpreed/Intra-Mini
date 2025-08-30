import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:marquee_text/marquee_text.dart';

class CursusSwitcher extends StatelessWidget {
  const CursusSwitcher(
      {super.key,
      required this.selectedCursus,
      required this.onCursusChanged,
      required this.cursusNames});
  final int? selectedCursus;
  final Function(String?) onCursusChanged;
  final Map<int, String> cursusNames;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      icon: Padding(
        padding: EdgeInsets.only(left: Layout.gutter),
        child: SvgPicture.asset(
          'assets/icons/dropdown_arrow.svg',
          colorFilter:
              ColorFilter.mode(context.myTheme.greyMain, BlendMode.srcIn),
          fit: BoxFit.none,
        ),
      ),
      menuWidth: Layout.cellWidth * 1.4,
      elevation: 0,
      menuMaxHeight: Layout.cellWidth * 2,
      underline: Container(),
      isDense: true,
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(color: context.myTheme.greyMain),
      dropdownColor: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(Layout.cellWidth / 4),
      value: cursusNames[selectedCursus],
      onChanged: onCursusChanged,
      items: cursusNames.entries.map((entry) {
        return DropdownMenuItem<String>(
          value: entry.value,
          child: Container(
            alignment: Alignment.centerRight,
            width: Layout.cellWidth,
            child: MarqueeText(
              text: TextSpan(text: entry.value),
              speed: 20,
            ),
          ),
        );
      }).toList(),
    );
  }
}
