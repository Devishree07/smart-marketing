import 'ai_service.dart';

class PortfolioGenerator {
  final AiService _ai = AiService();

  Future<String> generatePitch({
    required String ourBusinessName,
    required String ourServices,
    required String leadBusiness,
    required String leadIndustry,
  }) async {
    final prompt = '''
Write a 3-sentence compelling pitch explaining why our services are perfect for this business.

Our business: $ourBusinessName
Our services: $ourServices
Their business: $leadBusiness
Their industry: $leadIndustry

Rules:
- Be specific and confident
- Mention a clear benefit
- End with urgency or value
- Write only the pitch, nothing else
''';

    return await _ai.ask(prompt);
  }

  Future<Map<String, String>> generateFullPortfolio({
    required String ourBusinessName,
    required String ourServices,
    required String leadBusiness,
    required String leadIndustry,
  }) async {
    final prompt = '''
Create a mini portfolio pitch for this potential client.

Our business: $ourBusinessName
Our services: $ourServices
Their business: $leadBusiness
Their industry: $leadIndustry

Reply in this exact format:
HEADLINE: one catchy headline
PITCH: 2-3 sentence pitch
VALUE: one key value proposition
CTA: one call to action sentence
''';

    final result = await _ai.ask(prompt);
    final lines = result.split('\n');

    String headline = '';
    String pitch = '';
    String value = '';
    String cta = '';

    for (final line in lines) {
      if (line.startsWith('HEADLINE:')) {
        headline = line.replaceFirst('HEADLINE:', '').trim();
      } else if (line.startsWith('PITCH:')) {
        pitch = line.replaceFirst('PITCH:', '').trim();
      } else if (line.startsWith('VALUE:')) {
        value = line.replaceFirst('VALUE:', '').trim();
      } else if (line.startsWith('CTA:')) {
        cta = line.replaceFirst('CTA:', '').trim();
      }
    }

    return {
      'headline': headline,
      'pitch': pitch,
      'value': value,
      'cta': cta,
    };
  }
}