import 'lead.dart';

class SearchHistory {
  final String businessName;
  final String description;
  final String url;
  final String industry;
  final DateTime date;
  final List<Lead> leads;
  final List<Map<String, String>> competitors;
  final String positioning;

  SearchHistory({
    required this.businessName,
    required this.description,
    required this.url,
    required this.industry,
    required this.date,
    required this.leads,
    required this.competitors,
    required this.positioning,
  });
}
