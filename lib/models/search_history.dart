import 'package:flutter/material.dart';

class SearchHistory {
  final String businessName;
  final String description;
  final String url;
  final String industry;
  final DateTime date;

  SearchHistory({
    required this.businessName,
    required this.description,
    required this.url,
    required this.industry,
    required this.date,
  });
}