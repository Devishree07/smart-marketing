import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/lead.dart';

class ResultsScreen extends StatelessWidget {
  final List<Lead> leads;
  final List<Map<String, String>> competitors;
  final String positioning;

  const ResultsScreen({
    super.key,
    required this.leads,
    this.competitors = const [],
    this.positioning = '',
  });

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.indigo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Competitor Analysis Section
            if (competitors.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo.shade700, Colors.indigo.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.analytics, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Competitor Analysis',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...competitors.asMap().entries.map((entry) {
                      final index = entry.key;
                      final competitor = entry.value;
                      final medals = ['🥇', '🥈', '🥉'];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(medals[index],
                                    style: const TextStyle(fontSize: 16)),
                                const SizedBox(width: 8),
                                Text(competitor['name'] ?? '',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.white)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.warning_amber,
                                    size: 14, color: Colors.orange),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'Weakness: ${competitor['weakness']}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.orange),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.check_circle,
                                    size: 14, color: Colors.greenAccent),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'Your edge: ${competitor['positioning']}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.greenAccent),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                    if (positioning.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.lightbulb,
                                color: Colors.yellow, size: 16),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                positioning,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Leads Section
            const Text('Generated Leads',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            ...leads.map((lead) => Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.business, color: Colors.indigo),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(lead.businessName,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const Divider(height: 20),

                    // Generated Email
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Generated Email',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.indigo)),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 18),
                          onPressed: () => _copyToClipboard(
                              context, lead.generatedEmail),
                          tooltip: 'Copy email',
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(lead.generatedEmail,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black87)),
                    const SizedBox(height: 12),

                    // Portfolio Pitch
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Portfolio Pitch',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.indigo)),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 18),
                          onPressed: () => _copyToClipboard(
                              context, lead.portfolioPitch),
                          tooltip: 'Copy pitch',
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(lead.portfolioPitch,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black87)),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                final allText = [
                  if (competitors.isNotEmpty) ...[
                    'COMPETITOR ANALYSIS',
                    ...competitors.map((c) =>
                      '${c['name']}\nWeakness: ${c['weakness']}\nYour Edge: ${c['positioning']}'),
                    'Strategy: $positioning',
                    '---',
                  ],
                  'LEADS',
                  ...leads.map((lead) =>
                    'Business: ${lead.businessName}\n'
                    'Email: ${lead.generatedEmail}\n'
                    'Pitch: ${lead.portfolioPitch}\n'
                    '---'),
                ].join('\n');
                _copyToClipboard(context, allText);
              },
              icon: const Icon(Icons.download),
              label: const Text('Export All Results'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              icon: const Icon(Icons.home),
              label: const Text('Back to Home'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.white,
                foregroundColor: Colors.indigo,
                side: const BorderSide(color: Colors.indigo),
              ),
            ),
          ],
        ),
      ),
    );
  }
}