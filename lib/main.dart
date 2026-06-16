import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/leads_screen.dart';
import 'screens/results_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Marketing',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      routes: {
        '/leads': (context) => LeadsScreen(),
'/results': (context) => ResultsScreen(),
      },
    );
  }
}