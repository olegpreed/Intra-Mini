import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:forty_two_planet/core/home_layout.dart';
import 'package:forty_two_planet/pages/load_page/components/rotating_logo.dart';
import 'package:forty_two_planet/services/favourites_service.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/settings/user_settings.dart';
import 'package:forty_two_planet/utils/cache_utils.dart';
import 'package:provider/provider.dart';

class LoadPage extends StatefulWidget {
  const LoadPage({super.key});

  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    FlutterNativeSplash.remove();
    await fetchData();
    SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    await settingsProvider.loadSettings();
    await precacheSvgPictures([
      'assets/icons/success.svg',
      'assets/icons/fail.svg',
      'assets/icons/settings.svg',
      'assets/icons/wallet.svg',
      'assets/icons/eval.svg',
      'assets/icons/dropdown_arrow.svg',
    ]);
    setState(() {
      _isLoading = false;
    });
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const Home(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          animation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          );
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  Future<void> fetchData() async {
    final profileData = await UserService.fetchProfile(isHomeView: true);
    if (profileData.imageUrlBig != null) {
      final localImage =
          await MyProfileStore.loadProfileImage(profileData.imageUrlBig!);
      if (localImage != null) {
        await precacheImage(localImage, context);
      } else {
        await MyProfileStore.saveMyProfileImage(profileData.imageUrlBig!);
        await precacheImage(NetworkImage(profileData.imageUrlBig!), context);
      }
    }
    Color? color = await MyProfileStore.getCoalitionColor();
    if (color != null) {
      profileData.coalitionColor = color;
    } else {
      profileData.coalitionColor =
          await UserService.fetchCoalitionColor(profileData.login!);
      await MyProfileStore.saveMyCoalitionColor(profileData.coalitionColor!);
    }
    profileData.lastSeen = await UserService.fetchLastSeen(profileData.login!);
    profileData.weeklyLogTimesByMonth =
        await UserService.fetchMonthLogtime(profileData.login!);
    final profileStore = Provider.of<MyProfileStore>(context, listen: false);
    profileStore.setProfile(profileData);
    List<String> favs = await FavouriteStorage.loadFavourites(
        profileStore.userData.id.toString());
    profileStore.setFavouriteIds(favs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: AnimatedScale(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        scale: _isLoading ? 1.0 : 0,
        child: RotatingLogo(
          isLoading: _isLoading,
        ),
      )),
    );
  }
}
