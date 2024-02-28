import 'package:front/app_localizations.dart';
import 'package:front/constants.dart';
import 'package:flutter/material.dart';
import 'package:front/main.dart';

class LanguagesScreen extends StatefulWidget {
  const LanguagesScreen({Key? key}) : super(key: key);

  @override
  _LanguagesScreenState createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  String selectedLanguage = '';

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 30),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: AppStyles.primaryColor,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 36, right: 140, bottom: 36),
                  child: Text(
                    appLocalization.languages,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    appLocalization.suggested,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            buildLanguageRow(context, appLocalization.arabic),
            buildLanguageRow(context, appLocalization.french),
            buildLanguageRow(context, appLocalization.english),
          ],
        ),
      ),
    );
  }

  Widget buildLanguageRow(BuildContext context, String language) {
    final appLocalization = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(language),
          Radio<String>(
            activeColor: AppStyles.primaryColor,
            value: language,
            groupValue: selectedLanguage,
            onChanged: (value) {
              setState(() {
                selectedLanguage = value!;
                Locale newLocale;
                if (language == appLocalization.arabic) {
                  newLocale = const Locale('ar', 'SA');
                } else if (language == appLocalization.french) {
                  newLocale = const Locale('fr', 'FR');
                } else {
                  newLocale = const Locale('en', 'US');
                }
                MyApp.of(context)?.setLocale(newLocale);
              });
            },
          ),
        ],
      ),
    );
  }
}
