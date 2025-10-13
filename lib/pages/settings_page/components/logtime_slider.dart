import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forty_two_planet/settings/user_settings.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:provider/provider.dart';

class LogtimeSlider extends StatefulWidget {
  const LogtimeSlider({super.key});

  @override
  State<LogtimeSlider> createState() => _LogtimeSliderState();
}

class _LogtimeSliderState extends State<LogtimeSlider> {
  int _logtimeGoal = 30;

  @override
  void initState() {
    super.initState();
    _logtimeGoal = Provider.of<SettingsProvider>(context, listen: false)
        .get('logtimeGoal');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: Layout.gutter),
      height: Layout.cellWidth / 2.2,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Flexible(
            flex: 5,
            child: SliderTheme(
              data: SliderThemeData(
                thumbColor: Theme.of(context).primaryColor,
                activeTrackColor: Theme.of(context).scaffoldBackgroundColor,
                inactiveTrackColor: Theme.of(context).scaffoldBackgroundColor,
                overlayColor: Colors.transparent,
                trackHeight: Layout.padding / 2,
                thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: Layout.padding / 2),
              ),
              child: Slider(
                value: _logtimeGoal.toDouble(),
                min: 0,
                max: 60,
                divisions: 60,
                onChanged: (double value) {
                  if (!Platform.isAndroid) {
                    HapticFeedback.lightImpact();
                  }
                  Provider.of<SettingsProvider>(context, listen: false)
                      .saveASetting('logtimeGoal', value.round());
                  setState(() {
                    _logtimeGoal = value.round();
                  });
                },
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Text(
              '$_logtimeGoal h',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ],
      ),
    );
  }
}
