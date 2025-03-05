import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:forty_two_planet/core/auth_check.dart';
import 'package:forty_two_planet/core/home_layout.dart';
import 'package:forty_two_planet/services/campus_data_service.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/settings/user_settings.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/cache_utils.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // necessary for async functions before runApp
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await precacheSvgPictures(['assets/icons/login.svg']);
  await dotenv.load(fileName: ".env");
  final themeProvider = SettingsProvider();
  final prefs = await SharedPreferences.getInstance();
  await themeProvider.loadASetting('themeMode', prefs);
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
