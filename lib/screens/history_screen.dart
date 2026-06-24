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

  void _deleteItem(int index) {
    final deleted = _history[index];
    HistoryStore.removeAt(index);
    setState(() {});

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${deleted.businessName} removed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            HistoryStore.insertAt(index, deleted);
            setState(() {});
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void _showDeleteDialog(int index) {
    final item = _history[index];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete entry?'),
        content: Text('Remove "${item.businessName}" from history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteItem(index);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

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
                  return Dismissible(
                    key: ValueKey(item.hashCode),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => _deleteItem(index),
                    background: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete, color: Colors.white),
                          SizedBox(height: 4),
                          Text('Delete',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 11)),
                        ],
                      ),
                    ),
                    child: GestureDetector(
                      onLongPress: () => _showDeleteDialog(index),
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            child:
                                const Icon(Icons.business, color: Colors.white),
                          ),
                          title: Text(item.businessName),
                          subtitle: Text('${item.industry} • ${item.url}'),
                          trailing: Text(
                            '${item.date.day}/${item.date.month}/${item.date.year}',
                            style: const TextStyle(
                                fontSize: 11, color: Colors.grey),
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
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}