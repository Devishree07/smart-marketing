import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_keys.dart';
import 'api_keys.dart';

class AiService {
  static const String _apiKey = ApiKeys.groqKey;
  static const String _url = 'https://api.groq.com/openai/v1/chat/completions';

  Future<String> ask(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        Uri.parse(_url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'llama-3.3-70b-versatile',
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
          'model': 'llama-3.3-70b-versatile',
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
        }),
      );

      final data = jsonDecode(response.body);
      if (data['choices'] != null && data['choices'].isNotEmpty) {
        return data['choices'][0]['message']['content'];
      if (data['choices'] != null && data['choices'].isNotEmpty) {
        return data['choices'][0]['message']['content'];
      } else {
        return 'Error: ${response.body}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}