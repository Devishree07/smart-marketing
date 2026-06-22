import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class ThemeNotifier extends ValueNotifier<bool> {
  ThemeNotifier(bool value) : super(value);
}

class LanguageNotifier extends ValueNotifier<String> {
  LanguageNotifier(String value) : super(value);
}

class AccentNotifier extends ValueNotifier<Color> {
  AccentNotifier(Color value) : super(value);
}

final ThemeNotifier themeNotifier = ThemeNotifier(false);
final LanguageNotifier languageNotifier = LanguageNotifier('English');
final AccentNotifier accentNotifier = AccentNotifier(Colors.indigo);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: themeNotifier,
      builder: (context, isDarkMode, _) {
        return ValueListenableBuilder<String>(
          valueListenable: languageNotifier,
          builder: (context, language, __) {
            return ValueListenableBuilder<Color>(
              valueListenable: accentNotifier,
              builder: (context, accent, ___) {
                return MaterialApp(
                  title: 'Smart Marketing',
                  theme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(seedColor: accent),
                    useMaterial3: true,
                  ),
                  darkTheme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: accent,
                      brightness: Brightness.dark,
                    ),
                    useMaterial3: true,
                  ),
                  themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
                  home: const SplashScreen(),
                );
              },
            );
          },
        );
      },
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: accentNotifier,
      builder: (context, accent, _) {
        return Scaffold(
          body: _screens[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: accent,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
            ],
          ),
        );
      },
    );
  }
}