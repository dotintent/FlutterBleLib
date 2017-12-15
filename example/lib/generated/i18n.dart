import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class S {
  Locale _locale;
  String _lang;

  S(this._locale) {
    _lang = getLang(_locale);
    print(_lang);
  }

  static final GeneratedLocalizationsDelegate delegate =
      new GeneratedLocalizationsDelegate();

  static S of(BuildContext context) {
    var s = Localizations.of<S>(context, S);
    s._lang = getLang(s._locale);
    return s;
  }

}

class en extends S {
  en(Locale locale) : super(locale);
}
class GeneratedLocalizationsDelegate extends LocalizationsDelegate<S> {
  const GeneratedLocalizationsDelegate();

  List<Locale> get supportedLocales {
    return [
      new Locale("en", ""),
    ];
  }

  LocaleResolutionCallback resolution({Locale fallback}) {
    return (Locale locale, Iterable<Locale> supported) {
      var languageLocale = new Locale(locale.languageCode, "");
      if (supported.contains(locale))
        return locale;
      else if (supported.contains(languageLocale))
        return languageLocale;
      else {
        var fallbackLocale = fallback ?? supported.first;
        assert(supported.contains(fallbackLocale));
        return fallbackLocale;
      }
    };
  }

  Future<S> load(Locale locale) {
    String lang = getLang(locale);
    switch (lang) {
      case "en":
        return new SynchronousFuture<S>(new en(locale));
      default:
        return new SynchronousFuture<S>(new S(locale));
    }
  }

  bool isSupported(Locale locale) => supportedLocales.contains(getLang(locale));

  bool shouldReload(GeneratedLocalizationsDelegate old) => false;
}

String getLang(Locale l) =>
    l.countryCode.isEmpty ? l.languageCode : l.toString();
