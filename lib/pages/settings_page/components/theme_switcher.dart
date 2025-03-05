import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forty_two_planet/settings/user_settings.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:provider/provider.dart';

class ThemeSwitcher extends StatefulWidget {
  const ThemeSwitcher({super.key});

  @override
  State<ThemeSwitcher> createState() => _ThemeSwitcherState();
}

class _ThemeSwitcherState extends State<ThemeSwitcher> {
  int? _index = 1;

  final List<dynamic> _items = [
    {
      'type': SvgPicture,
      'path': 'assets/icons/sun.svg',
    },
    {
      'type': String,
      'text': 'auto',
    },
    {
      'type': SvgPicture,
      'path': 'assets/icons/moon.svg',
    },
  ];

  final List<ThemeMode> themeModeMapping = [
    ThemeMode.light,
    ThemeMode.system,
    ThemeMode.dark,
  ];

  @override
  Widget build(BuildContext context) {
    _index = themeModeMapping
        .indexOf(Provider.of<SettingsProvider>(context).get('themeMode'));
    double cellHeight = Layout.cellWidth / 2.2;
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.all(
            Radius.circular(cellHeight),
          ),
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_items.length, (index) {
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _index = index;
                      final themeMode = themeModeMapping[index];
                      Provider.of<SettingsProvider>(context, listen: false)
                          .saveASetting('themeMode', themeMode);
                    });
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    alignment: Alignment.center,
                    height: cellHeight,
                    child: _items[index]['type'] == SvgPicture
                        ? SvgPicture.asset(
                            _items[index]['path'],
                            colorFilter: ColorFilter.mode(
                                _index == index
                                    ? Theme.of(context).primaryColor
                                    : context.myTheme.greySecondary,
                                BlendMode.srcIn),
                          )
                        : Text(
                            _items[index]['text'],
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: _index == index
                                      ? Theme.of(context).primaryColor
                                      : context.myTheme.greySecondary,
                                ),
                          ),
                  ),
                ),
              );
            })));
  }
}
