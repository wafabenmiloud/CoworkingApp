import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:front/screens/login_screen.dart';
import 'package:front/constants.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          SvgPicture.asset(
            'images/logo.svg',
            height: 100,
            width: 70,
          ),
          Text(
            'CoWorkHome',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: Colors.white),
          ),
        ],
      ),
      backgroundColor: AppStyles.primaryColor,
      nextScreen: LoginScreen(),
      splashIconSize: 250,
      duration: 3800,
      splashTransition: SplashTransition.fadeTransition,
      animationDuration: Duration(seconds: 2),
    );
  }
}
