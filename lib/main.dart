import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:forty_two_planet/core/auth_check.dart';
import 'package:forty_two_planet/core/home_layout.dart';
import 'package:forty_two_planet/firebase_options.dart';
import 'package:forty_two_planet/services/campus_data_service.dart';
import 'package:forty_two_planet/services/remote_config_service.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/settings/user_settings.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/cache_utils.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> setupTimezone() async {
  tzdata.initializeTimeZones();

  TimezoneInfo tzInfo = await FlutterTimezone.getLocalTimezone();
  String identifier = tzInfo.identifier;

  final location = tz.getLocation(identifier);
  tz.setLocalLocation(location);
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding
      .ensureInitialized(); // necessary for async functions before runApp
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  await precacheSvgPictures(['assets/icons/login.svg']);
  await RemoteConfigService().init();
  final themeProvider = SettingsProvider();
  final prefs = await SharedPreferences.getInstance();
  await themeProvider.loadASetting('themeMode', prefs);
  await setupTimezone();
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosSettings = DarwinInitializationSettings();
  const settings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(settings);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => themeProvider),
    ChangeNotifierProvider(create: (context) => PageProvider()),
    ChangeNotifierProvider(create: (context) => CampusStore()),
    ChangeNotifierProvider(create: (context) => MyProfileStore()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    Layout.initialize(context);
    return MaterialApp(
      navigatorKey: navigatorKey, // necessary for logout to work
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: settings.get('themeMode'),
      home: const AuthCheck(),
    );
  }
}
