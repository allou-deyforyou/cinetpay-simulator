import 'dart:ui';

import 'package:flutter/foundation.dart';

class LocalizationService extends ValueNotifier<Locale> {
  LocalizationService()
      : super(Locale(
          PlatformDispatcher.instance.locale.languageCode.toLowerCase(),
        ));

  static LocalizationService? _instance;
  static LocalizationService get instance => _instance ??= LocalizationService();
}
