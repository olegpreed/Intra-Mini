import 'package:flutter/material.dart';
import 'package:forty_two_planet/settings/user_settings.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:provider/provider.dart';

class SettingsSwitch extends StatefulWidget {
  const SettingsSwitch(
      {super.key,
      required this.leftText,
      required this.rightText,
      required this.type});
  final String leftText;
  final String rightText;
  final String type;

  @override
  State<SettingsSwitch> createState() => _SettingsSwitchState();
}

class _SettingsSwitchState extends State<SettingsSwitch> {
  bool isLeftTrue = false;

  @override
  Widget build(BuildContext context) {
    isLeftTrue = Provider.of<SettingsProvider>(context).get(widget.type)!;
    return Container(
      height: Layout.cellWidth / 2.2,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Provider.of<SettingsProvider>(context, listen: false)
                    .saveASetting(widget.type, true);
              },
              behavior: HitTestBehavior.translucent,
              child: Container(
                alignment: Alignment.center,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 100),
                  child: Text(
                    widget.leftText,
                    key: ValueKey<bool>(isLeftTrue),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: isLeftTrue
                              ? Theme.of(context).primaryColor
                              : context.myTheme.greySecondary,
                        ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 2,
            margin: const EdgeInsets.symmetric(vertical: 10),
            color: context.myTheme.greySecondary,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Provider.of<SettingsProvider>(context, listen: false)
                    .saveASetting(widget.type, false);
              },
              behavior: HitTestBehavior.translucent,
              child: Container(
                alignment: Alignment.center,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 100),
                  child: Text(widget.rightText,
                      key: ValueKey<bool>(isLeftTrue),
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                              color: !isLeftTrue
                                  ? Theme.of(context).primaryColor
                                  : context.myTheme.greySecondary)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
