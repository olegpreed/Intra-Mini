import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forty_two_planet/core/home_layout.dart';
import 'package:forty_two_planet/pages/settings_page/settings_page.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:provider/provider.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class CornerButton extends StatelessWidget {
  const CornerButton({super.key, required this.isHomeView});
  final bool isHomeView;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: isHomeView
          ? () {
              Provider.of<PageProvider>(context, listen: false)
                  .setIsSettingsPage(true);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              ).then(
                (value) => Provider.of<PageProvider>(context, listen: false)
                    .setIsSettingsPage(false),
              );
            }
          : Navigator.of(context).pop,
      child: Padding(
        padding: EdgeInsets.only(top: Layout.gutter / 2, left: 10),
        child: Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: SvgPicture.asset(
              isHomeView
                  ? 'assets/icons/settings.svg'
                  : 'assets/icons/back.svg',
              colorFilter: ColorFilter.mode(
                  context.myTheme.greySecondary, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
