
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:brodbay/screens/home/home.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
     final bool isFirstTime = prefs.getBool('first_time') ?? true;
    await Future.delayed(const Duration(seconds: 2));
     if (!mounted) return;
     
     if (isFirstTime) {
      // Mark that the user has seen onboarding next time
      await prefs.setBool('first_time', false);

      // Go to onboarding
      Navigator.pushReplacementNamed(context, '/onboarding');
    } else {
      // Go directly to login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(splash: Column(
      children: [
        Flexible(
          child: Center(
            child: Image.asset("assets/logos/website-brodbay-logo.png",
            fit: BoxFit.contain,)
          ),
        )
      ],
    ), 
    nextScreen: HomeScreen(),
    splashIconSize: 400,
    backgroundColor: Colors.black);
  }
}