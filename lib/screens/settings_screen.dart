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

  final List<Color> _accentColors = [
    Colors.indigo,
    Colors.purple,
    Colors.teal,
    Colors.blue,
    Colors.pink,
    Colors.orange,
  ];

  final Map<Color, String> _colorNames = {
    Colors.indigo: 'Indigo',
    Colors.purple: 'Purple',
    Colors.teal: 'Teal',
    Colors.blue: 'Blue',
    Colors.pink: 'Pink',
    Colors.orange: 'Orange',
  };

  @override
  void initState() {
    super.initState();
    _darkMode = themeNotifier.value;
  }

  Future<void> _changeLanguage(String lang) async {
    setState(() => _isTranslating = true);
    try {
      await AppStrings.loadLanguage(lang);
      languageNotifier.value = lang;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Translation failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isTranslating = false);
    }
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
          ValueListenableBuilder<String>(
            valueListenable: languageNotifier,
            builder: (context, _, __) => ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(AppStrings.get('appearance'),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
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
              // accent color picker
              ValueListenableBuilder<Color>(
                valueListenable: accentNotifier,
                builder: (context, accent, _) {
                  return ListTile(
                    leading: const Icon(Icons.palette),
                    title: const Text('Accent Color'),
                    subtitle: Text(_colorNames[accent] ?? 'Custom'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: _accentColors.map((color) {
                        final isSelected = accent == color;
                        return GestureDetector(
                          onTap: () {
                            accentNotifier.value = color;
                            setState(() {});
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.onSurface
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? const Icon(Icons.check,
                                    color: Colors.white, size: 14)
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text(AppStrings.get('preferences'),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 13)),
              ),
              // FIX: Wrapped in ValueListenableBuilder so dropdown rebuilds when language changes
              ValueListenableBuilder<String>(
                valueListenable: languageNotifier,
                builder: (context, currentLang, _) {
                  return ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(AppStrings.get('language')),
                    subtitle: Text(currentLang),
                    trailing: DropdownButton<String>(
                      value: currentLang,
                      underline: const SizedBox(),
                      items: _languages.map((lang) {
                        return DropdownMenuItem(value: lang, child: Text(lang));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) _changeLanguage(val);
                      },
                    ),
                  );
                },
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text(AppStrings.get('about'),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
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