import 'ai_service.dart';

class CompetitorAnalyzer {
  final AiService _ai = AiService();

  Future<Map<String, dynamic>> analyzeCompetitors({
    required String businessName,
    required String businessUrl,
    required String industry,
    required String services,
  }) async {
    final prompt = '''
You are a business strategist. Analyze this company and find their top 3 real competitors.

Company: $businessName
Website: $businessUrl
Industry: $industry
Services: $services

Reply in this EXACT format, nothing else:
COMPETITOR1: [Real competitor name] | [Their weakness] | [How to position against them]
COMPETITOR2: [Real competitor name] | [Their weakness] | [How to position against them]
COMPETITOR3: [Real competitor name] | [Their weakness] | [How to position against them]
POSITIONING: [One overall positioning strategy sentence]
''';

    final result = await _ai.ask(prompt);
    final lines = result.split('\n');

    List<Map<String, String>> competitors = [];
    String positioning = '';

    for (final line in lines) {
      if (line.startsWith('COMPETITOR1:') ||
          line.startsWith('COMPETITOR2:') ||
          line.startsWith('COMPETITOR3:')) {
        final content = line.split(':').skip(1).join(':').trim();
        final parts = content.split(' | ');
        if (parts.length >= 3) {
          competitors.add({
            'name': parts[0].trim(),
            'weakness': parts[1].trim(),
            'positioning': parts[2].trim(),
          });
        }
      } else if (line.startsWith('POSITIONING:')) {
        positioning = line.replaceFirst('POSITIONING:', '').trim();
      }
    }

    return {
      'competitors': competitors,
      'positioning': positioning,
    };
  }
}