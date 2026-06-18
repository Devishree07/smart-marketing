import '../main.dart';
import '../services/app_strings.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _isTranslating = false;

  final List<String> _languages = [
    'English',
    'Hindi',
    'Kannada',
    'Tamil',
    'Telugu',
    'Marathi',
  ];

  @override
  void initState() {
    super.initState();
    _darkMode = themeNotifier.value;
  }

  Future<void> _changeLanguage(String lang) async {
    setState(() => _isTranslating = true);
    await AppStrings.loadLanguage(lang);
    languageNotifier.value = lang;
    setState(() => _isTranslating = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get('settings')),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(AppStrings.get('appearance'),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                        fontSize: 13)),
              ),
              SwitchListTile(
                title: Text(AppStrings.get('dark_mode')),
                subtitle: Text(AppStrings.get('dark_mode_sub')),
                secondary: const Icon(Icons.dark_mode),
                value: _darkMode,
                onChanged: (val) {
                  setState(() => _darkMode = val);
                  themeNotifier.value = val;
                },
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text(AppStrings.get('preferences'),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                        fontSize: 13)),
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(AppStrings.get('language')),
                subtitle: Text(languageNotifier.value),
                trailing: DropdownButton<String>(
                  value: languageNotifier.value,
                  underline: const SizedBox(),
                  items: _languages.map((lang) {
                    return DropdownMenuItem(value: lang, child: Text(lang));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) _changeLanguage(val);
                  },
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text(AppStrings.get('about'),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                        fontSize: 13)),
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: Text(AppStrings.get('version')),
                trailing: const Text('1.0.0'),
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: Text(AppStrings.get('clear_all_data'),
                    style: const TextStyle(color: Colors.red)),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Clear Data'),
                      content: const Text(
                          'Are you sure you want to clear all data?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Clear',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          if (_isTranslating)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text('Translating...',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}