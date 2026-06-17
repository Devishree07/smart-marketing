import '../models/lead.dart';
import 'analyzer.dart';
import 'email_gen.dart';
import 'portfolio_gen.dart';

class LeadService {
  final Analyzer _analyzer = Analyzer();
  final EmailGenerator _emailGen = EmailGenerator();
  final PortfolioGenerator _portfolioGen = PortfolioGenerator();

  Future<List<Lead>> generateLeads({
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

    // Step 1: Analyze the business using real name
    final analysis = await _analyzer.analyzeBusiness(
      businessName: realName,
      businessDescription: businessDescription,
      businessUrl: businessUrl,
    );

    final List<String> leadTypes = List<String>.from(analysis['leads']);
    final String services = (analysis['services'] as List).join(', ');
    final String industry = analysis['industry'];

    // Step 2: Generate a Lead for each lead type
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

    return leads;
  }
}