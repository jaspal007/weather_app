import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/screens/home.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      animationDuration: const Duration(seconds: 1),
      curve: Curves.linear,
      centered: true,
      splashTransition: SplashTransition.fadeTransition,
      splashIconSize: 500,
      splash: Center(
        child: Text(
          "Weather App",
          textAlign: TextAlign.center,
          style: GoogleFonts.orbitron(
            fontSize: 80,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: ThemeData.dark().primaryColor,
      nextScreen: const MyHome(),
    );
  }
}
