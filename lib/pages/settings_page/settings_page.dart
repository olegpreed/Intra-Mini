import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forty_two_planet/pages/settings_page/components/logtime_slider.dart';
import 'package:forty_two_planet/pages/settings_page/components/theme_switcher.dart';
import 'package:forty_two_planet/pages/settings_page/components/settings_switch.dart';
import 'package:forty_two_planet/core/home_layout.dart';
import 'package:forty_two_planet/main.dart';
import 'package:forty_two_planet/pages/login_page/login_page.dart';
import 'package:forty_two_planet/services/token_service.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> logout(BuildContext context) async {
    await TokenService.eraseStorage();
    SharedPreferences.getInstance().then((prefs) {
      prefs.clear();
    });
    String? profileImage = Provider.of<MyProfileStore>(context, listen: false)
        .userData
        .imageUrlBig;
    if (profileImage != null) {
      await MyProfileStore.deleteProfileImage(profileImage);
    }
    final pageProvider = Provider.of<PageProvider>(context, listen: false);
    pageProvider.setIsSettingsPage(false);
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const Login(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: context.myTheme.greyMain.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
                padding: EdgeInsets.only(
                    bottom: Layout.gutter * 1.5,
                    left: Layout.padding,
                    right: Layout.padding,
                    top: Layout.hasScreenBuffers ? 0 : Layout.gutter),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Settings',
                        style: Theme.of(context).textTheme.headlineLarge),
                    GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Provider.of<PageProvider>(context, listen: false)
                              .setIsSettingsPage(false);
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: SvgPicture.asset('assets/icons/back.svg',
                              fit: BoxFit.none,
                              colorFilter: ColorFilter.mode(
                                  context.myTheme.greySecondary,
                                  BlendMode.srcIn)),
                        )),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RawScrollbar(
                        radius: const Radius.circular(10),
                        padding: const EdgeInsets.only(right: 5),
                        thumbColor: context.myTheme.greyMain.withOpacity(0.3),
                        child: SingleChildScrollView(
                          child: Column(children: [
                            SizedBox(height: Layout.gutter * 1.5),
                            Text('Mode',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                        color: context.myTheme.greyMain)),
                            SizedBox(height: Layout.gutter * 1.5),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Layout.padding),
                              child: const ThemeSwitcher(),
                            ),
                            SizedBox(height: Layout.gutter * 1.5),
                            Divider(
                                color:
                                    context.myTheme.greyMain.withOpacity(0.3)),
                            SizedBox(height: Layout.gutter * 1.5),
                            Text('Exams in calendar',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                        color: context.myTheme.greyMain)),
                            SizedBox(height: Layout.gutter * 1.5),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Layout.padding),
                              child: const SettingsSwitch(
                                  leftText: 'Yes',
                                  rightText: 'No',
                                  type: 'fetchExams'),
                            ),
                            SizedBox(height: Layout.gutter * 1.5),
                            Text('(Requires app restart)',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: context.myTheme.greyMain)),
                            SizedBox(height: Layout.gutter * 1.5),
                            Divider(
                                color:
                                    context.myTheme.greyMain.withOpacity(0.3)),
                            SizedBox(height: Layout.gutter * 1.5),
                            Text('Logtime week goal',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                        color: context.myTheme.greyMain)),
                            SizedBox(height: Layout.gutter * 2),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Layout.padding),
                              child: const LogtimeSlider(),
                            ),
                            SizedBox(height: Layout.gutter * 1.5),
                            Divider(
                                color:
                                    context.myTheme.greyMain.withOpacity(0.3)),
                          ]),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          bottom: Layout.screenHeight * 0.02,
                          top: Layout.screenHeight * 0.02),
                      width: 176,
                      height: 70,
                      child: ElevatedButton(
                        onPressed: () => logout(context),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: context.myTheme.fail,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Log out'),
                            const SizedBox(width: 10),
                            SvgPicture.asset('assets/icons/logout.svg',
                                colorFilter: ColorFilter.mode(
                                    context.myTheme.fail, BlendMode.srcIn)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
