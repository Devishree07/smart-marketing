import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/lead.dart';

class ResultsScreen extends StatelessWidget {
  final List<Lead> leads;
  const ResultsScreen({super.key, required this.leads});

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
      body: leads.isEmpty
          ? const Center(child: Text('No results found.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: leads.length,
              itemBuilder: (context, index) {
                final lead = leads[index];
                return Card(
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
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                final allText = leads.map((lead) =>
                  'Business: ${lead.businessName}\n'
                  'Email: ${lead.generatedEmail}\n'
                  'Pitch: ${lead.portfolioPitch}\n'
                  '---'
                ).join('\n');
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