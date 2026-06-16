import 'package:flutter/material.dart';
import '../models/lead.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  final List<Map<String, String>> _results = const [
    {
      'business': 'Tech Solutions Ltd',
      'email': 'Subject: Partnership Opportunity\n\nHi Tech Solutions team,\n\nI came across your work and believe we can help grow your digital presence...',
      'pitch': 'Our portfolio includes 3 similar tech companies we helped scale 2x in 6 months.',
    },
    {
      'business': 'Creative Agency Co',
      'email': 'Subject: Collaboration Idea\n\nHi Creative Agency team,\n\nYour creative work caught our attention...',
      'pitch': 'We specialize in helping creative agencies automate their client outreach.',
    },
    {
      'business': 'Digital Marketing Hub',
      'email': 'Subject: Quick Question\n\nHi DMHub team,\n\nI noticed you help businesses with digital marketing...',
      'pitch': 'We have tools that can 3x your lead generation pipeline.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _results.length,
        itemBuilder: (context, index) {
          final result = _results[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(result['business']!,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const Divider(height: 20),
                  const Text('Generated Email',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.indigo)),
                  const SizedBox(height: 6),
                  Text(result['email']!,
                      style: const TextStyle(fontSize: 12, color: Colors.black87)),
                  const SizedBox(height: 12),
                  const Text('Portfolio Pitch',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.indigo)),
                  const SizedBox(height: 6),
                  Text(result['pitch']!,
                      style: const TextStyle(fontSize: 12, color: Colors.black87)),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.download),
          label: const Text('Export Results'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}