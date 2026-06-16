import 'ai_service.dart';

class Analyzer {
  final AiService _ai = AiService();

  Future<Map<String, dynamic>> analyzeBusiness({
    required String businessName,
    required String businessDescription,
    required String businessUrl,
  }) async {
    final prompt = '''
You are a business analyst. Analyze this business and return the following:
1. Main services they offer (list 3-5)
2. Their target audience
3. Their industry/niche
4. Potential leads they would want to reach (list 3-5 types of businesses)

Business Name: $businessName
Description: $businessDescription
Website: $businessUrl

Reply in this exact format:
SERVICES: service1, service2, service3
AUDIENCE: describe their target audience
INDUSTRY: their industry
LEADS: lead type1, lead type2, lead type3
''';

    final result = await _ai.ask(prompt);

    // Parse the response
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