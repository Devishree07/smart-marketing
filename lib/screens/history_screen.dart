import '../models/search_history.dart';
import '../services/history_store.dart';
import '../services/app_strings.dart';
import '../main.dart';
import 'package:flutter/material.dart';
import 'leads_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<SearchHistory> get _history => HistoryStore.all;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, _, __) => Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.get('search_history')),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () {
                setState(() => HistoryStore.clear());
              },
              tooltip: 'Clear history',
            ),
          ],
        ),
        body: _history.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.history, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(AppStrings.get('no_history'),
                        style: const TextStyle(color: Colors.grey)),
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
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LeadsScreen(
                              leads: item.leads,
                              competitors: item.competitors,
                              positioning: item.positioning,
                              showResultsButton: true,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}