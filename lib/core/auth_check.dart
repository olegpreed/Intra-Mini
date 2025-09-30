import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:forty_two_planet/pages/load_page/load_page.dart';
import 'package:forty_two_planet/pages/login_page/login_page.dart';
import 'package:forty_two_planet/services/token_service.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => AuthCheckState();
}

class AuthCheckState extends State<AuthCheck> {
  bool _tokensExistAndValid = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkForTokens();
    FlutterNativeSplash.remove();
  }

  void _checkForTokens() async {
    bool tokensExistAndValid = await TokenService.checkTokens();
    setState(() {
      _tokensExistAndValid = tokensExistAndValid;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Container());
    } else {
      return !_tokensExistAndValid ? const Login() : const LoadPage();
    }
  }
}
