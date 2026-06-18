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
  };

  static String get(String key) {
    if (currentLanguage == 'English') return _english[key] ?? key;
    return _cache[currentLanguage]?[key] ?? _english[key] ?? key;
  }

  static Future<void> loadLanguage(String language) async {
  if (language == 'English' || _cache.containsKey(language)) {
    currentLanguage = language;
    return;
  }

  final ai = AiService();
  final allText = _english.values.join(' ||| ');
  final prompt =
      'Translate each of these phrases to $language. Keep the same order, '
      'separate your answers with " ||| " exactly like the input, '
      'no extra text, no numbering:\n\n$allText';

  print('Sending translation request for: $language');
  final response = await ai.ask(prompt);
  print('AI Response: $response');

  final translated = response.split('|||').map((s) => s.trim()).toList();
  final keys = _english.keys.toList();

  print('Got ${translated.length} translations for ${keys.length} keys');

  final Map<String, String> langMap = {};
  for (int i = 0; i < keys.length && i < translated.length; i++) {
    langMap[keys[i]] = translated[i];
  }

  _cache[language] = langMap;
  currentLanguage = language;
  print('Language cache updated: ${_cache[language]}');
}
}