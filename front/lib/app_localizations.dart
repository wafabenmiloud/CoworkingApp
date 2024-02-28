import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'suggested': 'Suggested',
      'languages': 'Languages',
      'arabic': 'Arabic',
      'french': 'French',
      'english': 'English',
    },
    'ar': {
      'suggested': 'مقترح',
      'languages': 'اللغات',
      'arabic': 'العربية',
      'french': 'الفرنسية',
      'english': 'الإنجليزية',
    },
    'fr': {
      'suggested': 'Suggéré',
      'languages': 'Langues',
      'arabic': 'Arabe',
      'french': 'Français',
      'english': 'Anglais',
    },
  };

  String get suggested {
    return _localizedValues[locale.languageCode]!['suggested']!;
  }

  String get languages {
    return _localizedValues[locale.languageCode]!['languages']!;
  }

  String get arabic {
    return _localizedValues[locale.languageCode]!['arabic']!;
  }

  String get french {
    return _localizedValues[locale.languageCode]!['french']!;
  }

  String get english {
    return _localizedValues[locale.languageCode]!['english']!;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar', 'fr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

