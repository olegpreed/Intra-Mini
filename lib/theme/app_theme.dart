import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FontSize {
  static double scale(double baseSize) {
    final size = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    final double screenWidth = size.width;

    if (screenWidth <= 320) {
      return baseSize * 0.8; // iPhone SE (1st gen)
    } else if (screenWidth <= 375) {
      return baseSize * 0.95; // iPhone SE (3d gen)
    } else if (screenWidth <= 414) {
      return baseSize; // iPhone 12
    } else {
      return baseSize * 1.1; // iPhone Pro Max
    }
  }
}

class AppTheme {
  static Color intra = const Color(0xFF02C4C7);
  static ThemeData lightTheme() {
    const Color bg_0 = Color(0xFFF4F4F4);
    const Color bg_1 = Color(0xFFFFFFFF);
    const Color accent = Color(0xFF292D39);
    const Color greyMain = Color(0xFF828282);
    const Color greySecondary = Color(0xFFE1E1E1);
    const Color shimmer = Color.fromARGB(255, 240, 240, 240);
    const Color online = Color(0xFF7EFF93);
    const Color success = Color(0xFFA9DEAE);
    const Color fail = Color(0xFFEABDBD);
    const Color intra = Color(0xFF02C4C7);
    return ThemeData(
        fontFamily: 'Futura',
        cupertinoOverrideTheme: const CupertinoThemeData(
          primaryColor: Colors.blue,
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(
              fontSize: FontSize.scale(36),
              color: accent,
              fontWeight: FontWeight.bold),
          headlineLarge: TextStyle(fontSize: FontSize.scale(24), color: accent),
          headlineMedium:
              TextStyle(fontSize: FontSize.scale(20), color: accent),
          bodyMedium: TextStyle(fontSize: FontSize.scale(16), color: accent),
          bodySmall: TextStyle(fontSize: FontSize.scale(14), color: accent),
        ),
        scaffoldBackgroundColor: bg_0,
        cardColor: bg_1,
        primaryColor: accent,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.transparent,
            backgroundColor: bg_1,
            textStyle: TextStyle(
              fontSize: FontSize.scale(20),
              fontFamily: 'Futura',
            ),
            foregroundColor: accent,
          ),
        ),
        extensions: const <ThemeExtension<dynamic>>[
          MyTheme(
            greyMain: greyMain,
            greySecondary: greySecondary,
            shimmer: shimmer,
            online: online,
            success: success,
            fail: fail,
            intra: intra,
          )
        ]);
  }

  static ThemeData darkTheme() {
    const Color bg_0 = Color(0xFF000000);
    const Color bg_1 = Color(0xFF161616);
    const Color accent = Color(0xFFFFFFFF);
    const Color greyMain = Color(0xFF565656);
    const Color greySecondary = Color(0xFF535353);
    const Color shimmer = Color(0xFF232323);
    const Color online = Color(0xFF00FF1A);
    const Color success = Color(0xFFC4FFCA);
    const Color fail = Color(0xFFFFB8B8);
    const Color intra = Color(0xFF02C4C7);
    return ThemeData(
        fontFamily: 'Futura',
        cupertinoOverrideTheme: const CupertinoThemeData(
          primaryColor: Colors.blue,
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(
              fontSize: FontSize.scale(36),
              color: accent,
              fontWeight: FontWeight.bold),
          headlineLarge: TextStyle(fontSize: FontSize.scale(24), color: accent),
          headlineMedium:
              TextStyle(fontSize: FontSize.scale(20), color: accent),
          bodyMedium: TextStyle(fontSize: FontSize.scale(16), color: accent),
          bodySmall: TextStyle(fontSize: FontSize.scale(14), color: accent),
        ),
        scaffoldBackgroundColor: bg_0,
        cardColor: bg_1,
        primaryColor: accent,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.transparent,
            backgroundColor: bg_1,
            textStyle: TextStyle(
              fontSize: FontSize.scale(20),
              fontFamily: 'Futura',
            ),
            foregroundColor: accent,
          ),
        ),
        extensions: const <ThemeExtension<dynamic>>[
          MyTheme(
            greyMain: greyMain,
            greySecondary: greySecondary,
            shimmer: shimmer,
            online: online,
            success: success,
            fail: fail,
            intra: intra,
          )
        ]);
  }
}

extension MyThemeExtension on BuildContext {
  MyTheme get myTheme {
    final theme = Theme.of(this).extension<MyTheme>();
    assert(theme != null,
        'MyTheme extension should always be provided in ThemeData');
    return theme!;
  }
}

class MyTheme extends ThemeExtension<MyTheme> {
  const MyTheme(
      {this.greyMain = Colors.grey,
      this.greySecondary = Colors.grey,
      this.shimmer = Colors.grey,
      this.online = Colors.green,
      this.success = Colors.green,
      this.fail = Colors.red,
      this.intra = Colors.cyanAccent});

  final Color greyMain;
  final Color greySecondary;
  final Color shimmer;
  final Color online;
  final Color success;
  final Color fail;
  final Color intra;

  @override
  MyTheme copyWith({
    Color? greyMain,
    Color? greySecondary,
    Color? shimmer,
    Color? online,
    Color? success,
    Color? fail,
  }) {
    return MyTheme(
      greyMain: greyMain ?? this.greyMain,
      greySecondary: greySecondary ?? this.greySecondary,
      shimmer: shimmer ?? this.shimmer,
      online: online ?? this.online,
      success: success ?? this.success,
      fail: fail ?? this.fail,
    );
  }

  @override
  MyTheme lerp(MyTheme? other, double t) {
    if (other is! MyTheme) {
      return this;
    }
    return MyTheme(
      greyMain: Color.lerp(greyMain, other.greyMain, t)!,
      greySecondary: Color.lerp(greySecondary, other.greySecondary, t)!,
      shimmer: Color.lerp(shimmer, other.shimmer, t)!,
      online: Color.lerp(online, other.online, t)!,
      success: Color.lerp(success, other.success, t)!,
      fail: Color.lerp(fail, other.fail, t)!,
    );
  }
}
