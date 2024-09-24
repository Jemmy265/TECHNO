import 'package:flutter/material.dart';
import 'package:think/Features/Auth/view/register_screen.dart';
import 'package:think/Features/Home/home_screen.dart';
import 'package:think/shared_prefs.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = 'splash';

  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      final String email = SharedPrefs.getEmail();
      final String password = SharedPrefs.getPassword();
      (email.isNotEmpty && password.isNotEmpty)
          ? Navigator.pushReplacementNamed(context, HomeScreen.routeName)
          : Navigator.pushReplacementNamed(context, RegisterScreen.routeName);
    });
    return Scaffold(
      body: Image.asset(
        "assets/images/splash.png",
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
