import 'dart:ui';

import '../../../get_core/get_core.dart';

/// A private class to hold internationalization state.
class _IntlHost {
  /// The current locale.
  Locale? locale;

  /// The fallback locale to use when a translation is not found.
  Locale? fallbackLocale;

  /// Nested map of translations by locale and key.
  final Map<String, Map<String, String>> translations = {};
}

/// Extension on [List] to add a null-safe firstWhere method.
extension FirstWhereExt<T> on List<T> {
  /// Returns the first element that satisfies the given predicate [test], or null if none.
  ///
  /// Example:
  /// ```dart
  /// final list = [1, 2, 3];
  /// final even = list.firstWhereOrNull((n) => n % 2 == 0); // 2
  /// final negative = list.firstWhereOrNull((n) => n < 0); // null
  /// ```
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

/// Extension on [GetInterface] to provide internationalization support.
extension LocalesIntl on GetInterface {
  static final _intlHost = _IntlHost();

  /// Gets the current locale.
  Locale? get locale => _intlHost.locale;

  /// Gets the fallback locale.
  Locale? get fallbackLocale => _intlHost.fallbackLocale;

  /// Sets the current locale.
  set locale(Locale? newLocale) => _intlHost.locale = newLocale;

  /// Sets the fallback locale.
  set fallbackLocale(Locale? newLocale) => _intlHost.fallbackLocale = newLocale;

  /// Gets all translations.
  Map<String, Map<String, String>> get translations => _intlHost.translations;

  /// Adds translations to the current set.
  ///
  /// Example:
  /// ```dart
  /// Get.addTranslations({
  ///   'en_US': {'hello': 'Hello'},
  ///   'es_ES': {'hello': 'Hola'},
  /// });
  /// ```
  void addTranslations(Map<String, Map<String, String>> tr) {
    translations.addAll(tr);
  }

  /// Removes all translations.
  void clearTranslations() {
    translations.clear();
  }

  /// Appends translations to existing ones, merging them with existing locales.
  ///
  /// Example:
  /// ```dart
  /// // Existing: {'en_US': {'hello': 'Hello'}}
  /// Get.appendTranslations({
  ///   'en_US': {'goodbye': 'Goodbye'},
  ///   'es_ES': {'hello': 'Hola'},
  /// });
  /// // Result: {'en_US': {'hello': 'Hello', 'goodbye': 'Goodbye'}, 'es_ES': {'hello': 'Hola'}}
  /// ```
  void appendTranslations(Map<String, Map<String, String>> tr) {
    for (final entry in tr.entries) {
      translations.update(
        entry.key,
        (existing) => {...existing, ...entry.value},
        ifAbsent: () => Map.from(entry.value),
      );
    }
  }
}

/// Extension on [String] to add translation methods.
extension Trans on String {
  /// Checks if both the full locale (language_country) and key exist in translations.
  bool get _fullLocaleAndKey {
    final locale = Get.locale;
    if (locale?.languageCode == null || locale?.countryCode == null) return false;
    
    final localeKey = '${locale!.languageCode}_${locale.countryCode}';
    return Get.translations.containsKey(localeKey) && 
           Get.translations[localeKey]!.containsKey(this);
  }

  /// Gets translations for a similar language (matching language code only).
  Map<String, String>? get _getSimilarLanguageTranslation {
    final locale = Get.locale;
    if (locale?.languageCode == null) return null;
    
    final langCode = locale!.languageCode.split('_').first;
    return Get.translations.entries
        .toList()
        .firstWhereOrNull((e) => e.key.startsWith('${langCode}_'))
        ?.value;
  }

  /// Translates the string using the current locale.
  ///
  /// Returns the translated string if found, otherwise returns the original key.
  ///
  /// Example:
  /// ```dart
  /// // With translations: {'en_US': {'hello': 'Hello'}}
  /// 'hello'.tr;  // 'Hello' (if locale is en_US)
  /// 'missing'.tr; // 'missing' (key not found)
  /// ```
  String get tr {
    final currentLocale = Get.locale;
    if (currentLocale?.languageCode == null) return this;

    // Try full locale match first (e.g., 'en_US')
    if (_fullLocaleAndKey) {
      return Get.translations['${currentLocale!.languageCode}_${currentLocale.countryCode}']![this]!;
    }

    // Try language code only (e.g., 'en')
    final similarTranslation = _getSimilarLanguageTranslation;
    if (similarTranslation != null && similarTranslation.containsKey(this)) {
      return similarTranslation[this]!;
    }

    // Try fallback locale if available
    final fallback = Get.fallbackLocale;
    if (fallback != null) {
      final fallbackKey = '${fallback.languageCode}_${fallback.countryCode}';
      
      if (Get.translations.containsKey(fallbackKey) && 
          Get.translations[fallbackKey]!.containsKey(this)) {
        return Get.translations[fallbackKey]![this]!;
      }
      
      if (Get.translations.containsKey(fallback.languageCode) &&
          Get.translations[fallback.languageCode]!.containsKey(this)) {
        return Get.translations[fallback.languageCode]![this]!;
      }
    }

    return this;
  }

  /// Translates the string with positional arguments.
  ///
  /// Replaces `%s` placeholders with the provided arguments in order.
  ///
  /// Example:
  /// ```dart
  /// // With translations: {'en_US': {'welcome': 'Hello %s, welcome to %s!'}}
  /// 'welcome'.trArgs(['John', 'GetX']);  // 'Hello John, welcome to GetX!'
  /// ```
  String trArgs([List<String> args = const []]) {
    if (args.isEmpty) return tr;
    
    var result = tr;
    for (final arg in args) {
      result = result.replaceFirst(RegExp(r'%s'), arg);
    }
    return result;
  }

  /// Returns the singular or plural form based on the count.
  ///
  /// Example:
  /// ```dart
  /// // With translations: 
  /// // {'en_US': {'item': '1 item', 'items': '%s items'}}
  /// 'item'.trPlural('items', 1);  // '1 item'
  /// 'item'.trPlural('items', 5);  // '5 items'
  /// ```
  String trPlural([String? pluralKey, int? count, List<String> args = const []]) {
    return (count == 1 ? this : pluralKey ?? this).trArgs(args);
  }

  /// Translates the string with named parameters.
  ///
  /// Replaces `@key` placeholders with values from the params map.
  ///
  /// Example:
  /// ```dart
  /// // With translations: 
  /// // {'en_US': {'greeting': 'Hello @name, welcome to @app!'}}
  /// 'greeting'.trParams({'name': 'John', 'app': 'GetX'});
  /// // 'Hello John, welcome to GetX!'
  /// ```
  String trParams([Map<String, String> params = const {}]) {
    if (params.isEmpty) return tr;
    
    return params.entries.fold(
      tr,
      (result, entry) => result.replaceAll('@${entry.key}', entry.value),
    );
  }

  /// Returns the singular or plural form with named parameters.
  ///
  /// Combines [trPlural] and [trParams] functionality.
  ///
  /// Example:
  /// ```dart
  /// // With translations: 
  /// // {'en_US': {
  /// //   'item': '1 item remaining',
  /// //   'items': '@count items remaining'
  /// // }}
  /// 'item'.trPluralParams('items', 5, {'count': '5'});  // '5 items remaining'
  /// ```
  String trPluralParams(
    [String? pluralKey, 
     int? count, 
     Map<String, String> params = const {}
  ]) {
    return (count == 1 ? this : pluralKey ?? this).trParams(params);
  }
}
