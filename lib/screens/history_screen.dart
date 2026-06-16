import '../models/search_history.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late final List<SearchHistory> _history;

  @override
  void initState() {
    super.initState();
    _history = [
      SearchHistory(
        businessName: 'Tech Solutions Ltd',
        description: 'Software development company',
        url: 'techsolutions.com',
        industry: 'Technology',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      SearchHistory(
        businessName: 'Creative Agency Co',
        description: 'Design and branding agency',
        url: 'creativeagency.com',
        industry: 'Marketing',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search History'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              setState(() => _history.clear());
            },
            tooltip: 'Clear history',
          ),
        ],
      ),
      body: _history.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No search history yet.',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final item = _history[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.indigo,
                      child: Icon(Icons.business, color: Colors.white),
                    ),
                    title: Text(item.businessName),
                    subtitle: Text('${item.industry} • ${item.url}'),
                    trailing: Text(
                      '${item.date.day}/${item.date.month}/${item.date.year}',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    onTap: () {},
                  ),
                );
              },
            ),
    );
  }
}