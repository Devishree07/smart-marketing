import 'ai_service.dart';

class AppStrings {
  static String currentLanguage = 'English';
  static final Map<String, Map<String, String>> _cache = {};

  static const Map<String, String> _english = {
    'app_title': 'Smart Marketing',
    'enter_business_details': 'Enter Business Details',
    'business_name': 'Business Name',
    'business_description': 'Business Description',
    'website_url': 'Website URL (https://...)',
    'industry': 'Industry',
    'find_leads': 'Find Leads',
    'finding_leads': 'Finding Leads...',
    'fill_all_fields': 'Please fill in all fields first!',
    'home': 'Home',
    'history': 'History',
    'settings': 'Settings',
    'discovered_leads': 'Discovered Leads',
    'search_leads': 'Search leads...',
    'see_results': 'See Results',
    'results': 'Results',
    'export_all': 'Export All Results',
    'back_to_home': 'Back to Home',
    'appearance': 'Appearance',
    'dark_mode': 'Dark Mode',
    'dark_mode_sub': 'Switch to dark theme',
    'preferences': 'Preferences',
    'language': 'Language',
    'about': 'About',
    'version': 'Version',
    'clear_all_data': 'Clear All Data',
    'search_history': 'Search History',
    'no_history': 'No search history yet.',
    'accent_color': 'Accent Color',
    'indigo': 'Indigo',
    'purple': 'Purple',
    'teal': 'Teal',
    'blue': 'Blue',
    'pink': 'Pink',
    'orange': 'Orange',
    'custom': 'Custom',
    'analyzing_business': 'Analyzing your business...',
    'identifying_leads': 'Identifying target leads...',
    'writing_emails': 'Writing personalized emails...',
    'researching_competitors': 'Researching competitors...',
    'almost_done': 'Almost done...',
  };

  static String get(String key) {
    if (currentLanguage == 'English') return _english[key] ?? key;
    return _cache[currentLanguage]?[key] ?? _english[key] ?? key;
  }

  static Future<void> loadLanguage(String language) async {
    if (language == 'English') {
      currentLanguage = language;
      return;
    }

    // Already cached — just switch
    if (_cache.containsKey(language)) {
      currentLanguage = language;
      return;
    }

    final ai = AiService();
    final keys = _english.keys.toList();
    final allText = keys.map((k) => _english[k]!).join(' ||| ');
    final prompt =
        'Translate each of these phrases to $language. '
        'Keep the exact same order and count. '
        'Separate each translation with " ||| " exactly. '
        'Output ONLY the translations, no numbering, no extra text, no explanation:\n\n$allText';

    try {
      final response = await ai.ask(prompt);

      // Bail out if AI returned an error string
      if (response.startsWith('Error:')) {
        throw Exception(response);
      }

      final translated = response.split('|||').map((s) => s.trim()).toList();

      // Only store if we got the right number of translations
      if (translated.length != keys.length) {
        throw Exception(
            'Translation count mismatch: expected ${keys.length}, got ${translated.length}');
      }

      final Map<String, String> langMap = {};
      for (int i = 0; i < keys.length; i++) {
        final t = translated[i];
        // Skip if a translation looks like an error or is empty
        langMap[keys[i]] = (t.isEmpty || t.startsWith('Error')) ? _english[keys[i]]! : t;
      }

      _cache[language] = langMap;
      currentLanguage = language;
    } catch (e) {
      // Don't update currentLanguage — keep whatever was set before
      rethrow; // Let _changeLanguage in settings_screen show the error
    }
  }
}