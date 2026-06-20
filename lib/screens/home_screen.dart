import 'dart:async';
import 'package:flutter/material.dart';
import '../services/lead_service.dart';
import '../services/history_store.dart';
import '../models/search_history.dart';
import 'leads_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _urlController = TextEditingController();
  String _selectedIndustry = 'Technology';
  bool _isLoading = false;
  int _currentMessageIndex = 0;
  Timer? _messageTimer;

  final List<String> _industries = [
    'Technology', 'Healthcare', 'Finance', 'Education',
    'Retail', 'Marketing', 'Real Estate', 'Food & Beverage',
    'Entertainment', 'Other',
  ];

  final List<String> _loadingMessages = [
    '🔍 Analyzing your business...',
    '🎯 Identifying target leads...',
    '✉️ Writing personalized emails...',
    '📊 Researching competitors...',
    '🚀 Almost done...',
  ];

  @override
  void dispose() {
    _messageTimer?.cancel();
    super.dispose();
  }

  Future<void> _findLeads() async {
    if (_nameController.text.isEmpty ||
        _descController.text.isEmpty ||
        _urlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields first!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final url = _urlController.text.trim();
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid URL starting with https://'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final uri = Uri.tryParse(url);
    if (uri == null || uri.host.isEmpty || !uri.host.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a real business website URL!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _currentMessageIndex = 0;
    });

    _messageTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (mounted) {
        setState(() {
          _currentMessageIndex =
              (_currentMessageIndex + 1) % _loadingMessages.length;
        });
      }
    });

    try {
      final result = await LeadService().generateLeadsWithCompetitors(
        businessName: _nameController.text,
        businessDescription: _descController.text,
        businessUrl: _urlController.text,
      );

      HistoryStore.add(SearchHistory(
        businessName: _nameController.text,
        description: _descController.text,
        url: _urlController.text,
        industry: _selectedIndustry,
        date: DateTime.now(),
      ));

      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LeadsScreen(
            leads: result['leads'],
            competitors: result['competitors'],
            positioning: result['positioning'],
            showResultsButton: true,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      _messageTimer?.cancel();
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Marketing'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Enter Business Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Business Name',
                prefixIcon: Icon(Icons.business),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Business Description',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Website URL (https://...)',
                prefixIcon: Icon(Icons.link),
                border: OutlineInputBorder(),
                hintText: 'https://example.com',
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedIndustry,
              decoration: const InputDecoration(
                labelText: 'Industry',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              items: _industries.map((industry) {
                return DropdownMenuItem(
                  value: industry,
                  child: Text(industry),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedIndustry = value!);
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _findLeads,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.search),
              label: Text(
                _isLoading
                    ? _loadingMessages[_currentMessageIndex]
                    : 'Find Leads',
                style: const TextStyle(fontSize: 15),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}