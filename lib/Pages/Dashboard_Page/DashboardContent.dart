import 'package:ai_skinwise_v2/Supabase/user_data_service.dart';
import 'package:flutter/material.dart';

class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  // --- IT'S NOW CORRECT TO USE DashboardData ---
  late Future<DashboardData> _dashboardData;

  @override
  void initState() {
    super.initState();
    // --- AND CORRECT TO CALL fetchDashboardData ---
    _dashboardData = fetchDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DashboardData>(
      future: _dashboardData, // Call the main dashboard fetcher
      builder: (context, snapshot) {
        // --- 1. LOADING STATE ---
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // --- 2. ERROR STATE ---
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Error loading data: ${snapshot.error}. \n\nEnsure a user is logged in and RLS policies are correct.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        // --- 3. DATA LOADED SUCCESS STATE ---
        if (snapshot.hasData) {
          final data = snapshot.data!;
          final fullName =
          '${data.firstName ?? ''} ${data.lastName ?? ''}'.trim();

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Header (User Name)
              Text(
                fullName.isEmpty ? 'Welcome Back!' : 'Welcome, $fullName!',
                style:
                const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Section Title: Discovered Diseases
              const Text(
                'Discovered Skin Diseases',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey),
              ),
              const Divider(),

              // --- THIS SECTION WILL NOW WORK ---
              if (data.analysisHistory.isEmpty)
                const Text('No analysis history found yet.'),

              // List of Discovered Diseases
              ...data.analysisHistory.map((record) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.check_circle_outline,
                        color: Colors.blueAccent),
                    title: Text(record.diseaseName,
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: Text(
                        'Date: ${record.analysisDate} | Rarity: ${record.rarity ?? 'N/A'}'),
                    trailing: Text(
                      'Confidence: ${(record.confidenceScore * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: record.confidenceScore > 0.8
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),
                    onTap: () {
                      // TODO: Implement navigation to DiseaseDetailPage
                      print('Navigating to detail for ${record.diseaseName}');
                    },
                  ),
                );
              }).toList(),
            ],
          );
        }

        // Default Fallback
        return const Center(child: Text('Initializing dashboard...'));
      },
    );
  }
}