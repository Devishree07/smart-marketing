import 'package:flutter/material.dart';
import '../models/lead.dart';
import 'results_screen.dart';

class LeadsScreen extends StatefulWidget {
  final bool showResultsButton;
  final List<Lead> leads;

  const LeadsScreen({
    super.key,
    this.showResultsButton = false,
    required this.leads,
  });

  @override
  State<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
  List<Lead> _filteredLeads = [];
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredLeads = List.from(widget.leads);
    _searchController.addListener(_filterLeads);
  }

  void _filterLeads() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredLeads = widget.leads.where((lead) =>
        lead.businessName.toLowerCase().contains(query) ||
        lead.contactEmail.toLowerCase().contains(query)
      ).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discovered Leads'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search leads...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          Expanded(
            child: _filteredLeads.isEmpty
                ? const Center(child: Text('No leads found.'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _filteredLeads.length,
                    itemBuilder: (context, index) {
                      final lead = _filteredLeads[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.business,
                                      color: Colors.indigo),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(lead.businessName,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(lead.portfolioPitch,
                                  style: const TextStyle(
                                      color: Colors.black87, fontSize: 13)),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.indigo.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text('AI Generated',
                                    style: TextStyle(
                                        fontSize: 11, color: Colors.indigo)),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (widget.showResultsButton)
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ResultsScreen(
                        leads: widget.leads,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('See Results'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}