import 'ai_service.dart';

class Analyzer {
  final AiService _ai = AiService();

  Future<Map<String, dynamic>> analyzeBusiness({
    required String businessName,
    required String businessDescription,
    required String businessUrl,
  }) async {
    final prompt = '''
You are a business analyst. Analyze this business carefully.

Business Name: $businessName
Description: $businessDescription
Website: $businessUrl

Reply in this EXACT format, nothing else, no extra text:
SERVICES: service1, service2, service3
AUDIENCE: describe their target audience in one line
INDUSTRY: one word or short phrase
LEADS: lead type1, lead type2, lead type3, lead type4, lead type5
''';

    final result = await _ai.ask(prompt);
    final lines = result.split('\n');

    List<String> services = [];
    List<String> leads = [];
    String audience = '';
    String industry = '';

    for (final line in lines) {
      if (line.startsWith('SERVICES:')) {
        services = line.replaceFirst('SERVICES:', '').trim().split(', ');
      } else if (line.startsWith('AUDIENCE:')) {
        audience = line.replaceFirst('AUDIENCE:', '').trim();
      } else if (line.startsWith('INDUSTRY:')) {
        industry = line.replaceFirst('INDUSTRY:', '').trim();
      } else if (line.startsWith('LEADS:')) {
        leads = line.replaceFirst('LEADS:', '').trim().split(', ');
      }
    }

    return {
      'services': services,
      'audience': audience,
      'industry': industry,
      'leads': leads,
    };
  }
}