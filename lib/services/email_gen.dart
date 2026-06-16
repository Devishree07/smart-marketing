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
Write a short, professional cold outreach email.

We are: $ourBusinessName
Our services: $ourServices
We are reaching out to: $leadName from $leadBusiness
Their industry: $leadIndustry

Rules:
- Keep it under 100 words
- Be friendly and specific
- Mention how our services help their business
- End with a call to action
- Do not use generic phrases like "I hope this email finds you well"

Write only the email body, no subject line.
''';

    return await _ai.ask(prompt);
  }

  Future<String> generateSubject({
    required String leadBusiness,
    required String ourServices,
  }) async {
    final prompt = '''
Write a short catchy email subject line for a cold outreach email.
We are offering: $ourServices
Reaching out to: $leadBusiness
Return only the subject line, nothing else. Max 8 words.
''';

    return await _ai.ask(prompt);
  }
}