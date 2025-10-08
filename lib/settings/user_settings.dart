import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  final Map<String, dynamic> _settings = {
    'themeMode': ThemeMode.system,
    'fetchExams': true,
    'levelRange': const RangeValues(0, 21),
    'onlyFavorites': false,
    'logtimeGoal': 30,
  };

  dynamic get(String key) {
    if (_settings.containsKey(key)) {
      return _settings[key];
    } else {
      throw ArgumentError('Invalid key: $key');
    }
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    for (var setting in _settings.keys) {
      await loadASetting(setting, prefs);
    }
  }

  bool get isDarkMode {
    final themeMode = _settings['themeMode'] as ThemeMode;
    if (themeMode == ThemeMode.system) {
      return PlatformDispatcher.instance.platformBrightness == Brightness.dark;
    }
    return themeMode == ThemeMode.dark;
  }

  Future<void> loadASetting(String setting, SharedPreferences prefs) async {
    if (setting == 'themeMode') {
      final themeIndex = prefs.getInt('themeMode') ?? ThemeMode.system.index;
      _settings['themeMode'] = ThemeMode.values[themeIndex];
    } else if (setting == 'levelRange') {
      final min = prefs.getDouble('levelRangeMin') ?? 0;
      final max = prefs.getDouble('levelRangeMax') ?? 21;
      _settings['levelRange'] = RangeValues(min, max);
    } else if (setting == 'logtimeGoal') {
      final value = prefs.getInt('logtimeGoal') ?? 0;
      _settings['logtimeGoal'] = value;
    } else {
      final value = prefs.getBool(setting);
      if (value != null) {
        _settings[setting] = value;
      }
    }
    notifyListeners();
  }

  Future<void> saveASetting(String setting, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (setting == 'themeMode') {
      prefs.setInt('themeMode', value.index);
    } else if (setting == 'levelRange') {
      prefs.setDouble('levelRangeMin', value.start);
      prefs.setDouble('levelRangeMax', value.end);
    } else if (setting == 'logtimeGoal') {
      prefs.setInt('logtimeGoal', value);
    } else {
      prefs.setBool(setting, value);
    }
    _settings[setting] = value;
    notifyListeners();
  }

  // void resetSettings() async {
  //   _settings['themeMode'] = ThemeMode.system;
  //   _settings['is12HourFormat'] = true;
  //   _settings['isMondayFirst'] = true;
  //   _settings['fetchExams'] = true;
  //   _settings['levelRange'] = const RangeValues(0, 21);
  //   _settings['logtimeGoal'] = 30;
  //   final prefs = await SharedPreferences.getInstance();
  //   final keys = prefs.getKeys();
  //   if (keys.isEmpty) {
  //     return;
  //   }
  //   for (var key in keys) {
  //     prefs.remove(key);
  //   }
  //   notifyListeners();
  // }
}
