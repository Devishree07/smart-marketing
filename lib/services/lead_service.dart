import '../models/lead.dart';
import '../screens/settings_screen.dart';
import 'analyzer.dart';
import 'email_gen.dart';
import 'portfolio_gen.dart';
import 'competitor_analyzer.dart';

class LeadService {
  final Analyzer _analyzer = Analyzer();
  final EmailGenerator _emailGen = EmailGenerator();
  final PortfolioGenerator _portfolioGen = PortfolioGenerator();
  final CompetitorAnalyzer _competitorAnalyzer = CompetitorAnalyzer();

  Future<Map<String, dynamic>> generateLeadsWithCompetitors({
    required String businessName,
    required String businessDescription,
    required String businessUrl,
  }) async {

    // Extract real business name from URL
    final uri = Uri.tryParse(businessUrl);
    String realName = businessName;
    if (uri != null && uri.host.isNotEmpty) {
      realName = uri.host
          .replaceAll('www.', '')
          .split('.')[0];
      realName = realName[0].toUpperCase() + realName.substring(1);
    }

    // Step 1: Analyze the business
    final analysis = await _analyzer.analyzeBusiness(
      businessName: realName,
      businessDescription: businessDescription,
      businessUrl: businessUrl,
    );

    // Use lead count from settings
    final List<String> allLeadTypes = List<String>.from(analysis['leads']);
    final List<String> leadTypes = allLeadTypes
        .take(leadCountNotifier.value)
        .toList();

    final String services = (analysis['services'] as List).join(', ');
    final String industry = analysis['industry'];

    // Step 2: Analyze competitors
    final competitorData = await _competitorAnalyzer.analyzeCompetitors(
      businessName: realName,
      businessUrl: businessUrl,
      industry: industry,
      services: services,
    );

    // Step 3: Generate leads
    List<Lead> leads = [];

    for (final leadType in leadTypes) {
      final emailBody = await _emailGen.generateEmail(
        ourBusinessName: realName,
        ourServices: services,
        leadName: leadType,
        leadBusiness: leadType,
        leadIndustry: industry,
      );

      final pitch = await _portfolioGen.generatePitch(
        ourBusinessName: realName,
        ourServices: services,
        leadBusiness: leadType,
        leadIndustry: industry,
      );

      leads.add(Lead(
        businessName: leadType,
        contactEmail: '',
        generatedEmail: emailBody,
        portfolioPitch: pitch,
      ));
    }

    return {
      'leads': leads,
      'competitors': competitorData['competitors'],
      'positioning': competitorData['positioning'],
    };
  }

  // Keep old method for compatibility
  Future<List<Lead>> generateLeads({
    required String businessName,
    required String businessDescription,
    required String businessUrl,
  }) async {
    final result = await generateLeadsWithCompetitors(
      businessName: businessName,
      businessDescription: businessDescription,
      businessUrl: businessUrl,
    );
    return result['leads'];
  }
}