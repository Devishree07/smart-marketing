import 'package:flutter/material.dart';
import 'services/ai_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final ai = AiService();
  final result = await ai.ask('Say hello in one sentence');
  print('AI Response: $result');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Check terminal for AI response!'),
        ),
      ),
    );
  }
}