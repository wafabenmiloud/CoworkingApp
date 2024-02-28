import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:front/app_localizations.dart';
import 'package:front/screens/login_screen.dart';
import 'package:front/screens/messages_screen.dart';
import 'package:front/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:front/services/authservice.dart';
import 'package:front/widgets/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('fr_FR', null);
  Stripe.publishableKey = "$StripePublishKey";
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static _MyAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MyAppState>();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale _currentLocale;
  @override
  void initState() {
    super.initState();
    _currentLocale = const Locale('en', 'US'); // Set the default locale
  }

  void setLocale(Locale locale) {
    setState(() {
      _currentLocale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final prefs = snapshot.data as SharedPreferences;
          final isLogin = prefs.getBool('isLogin') ?? false;
          return MaterialApp(
            localizationsDelegates: [
              AppLocalizationsDelegate(), // Add the custom delegate
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en', 'US'), // English
              const Locale('ar', 'SA'), // Arabic
              const Locale('fr', 'FR'), // French
            ],
            locale: _currentLocale, // Set the current locale
            debugShowCheckedModeBanner: false,
            home: isLogin ? const Navbar() : WelcomeScreen(),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
