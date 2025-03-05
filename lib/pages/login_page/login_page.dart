import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:forty_two_planet/pages/load_page/load_page.dart';
import 'package:forty_two_planet/pages/login_page/components/login_btn.dart';
import 'package:forty_two_planet/pages/login_page/components/login_globe.dart';
import 'package:forty_two_planet/pages/login_page/components/login_headlines.dart';
import 'package:forty_two_planet/services/logger_service.dart';
import 'package:forty_two_planet/services/token_service.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  void _login() async {
    try {
      if (await TokenService.requestAndSaveUserToken() &&
          await TokenService.requestAndSaveAppToken()) {
        onLoginSuccess();
      }
    } on FlutterAppAuthUserCancelledException {
      logger.d('User cancelled login');
      return;
    } on FlutterAppAuthPlatformException catch (e) {
      await showErrorDialog(e.message ?? e.toString());
      return;
    } catch (e) {
      await showErrorDialog(e.toString());
      return;
    }
  }

  void onLoginSuccess() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoadPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 200),
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Transform.translate(
              offset: Offset(0, Layout.screenHeight / 6),
              child: const LoginGlobe()),
          LoginHeadlines(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                  left: Layout.padding,
                  right: Layout.padding,
                  bottom: Layout.hasScreenBuffers ? 0 : Layout.padding),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: LoginBtn(onPressed: _login),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
