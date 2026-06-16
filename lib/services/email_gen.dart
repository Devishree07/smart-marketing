import 'ai_service.dart';

class EmailGenerator {
  final AiService _ai = AiService();

  Future<String> generateEmail({
    required String ourBusinessName,
    required String ourServices,
    required String leadName,
    required String leadBusiness,
    required String leadIndustry,
  }) async {
    final prompt = '''
Write a cold outreach email. Be specific, friendly and professional.

From: $ourBusinessName
Our services: $ourServices
To: $leadBusiness (in $leadIndustry industry)

Rules:
- Max 80 words
- No "I hope this finds you well"
- Mention exactly how we help their business
- End with a clear call to action
- Write only the email body, no subject line
''';

    return await _ai.ask(prompt);
  }

  Future<String> generateSubject({
    required String leadBusiness,
    required String ourServices,
  }) async {
    final prompt = '''
Write a catchy cold email subject line.
We offer: $ourServices
Writing to: $leadBusiness
Max 8 words. Return only the subject line.
''';

    return await _ai.ask(prompt);
  }
}