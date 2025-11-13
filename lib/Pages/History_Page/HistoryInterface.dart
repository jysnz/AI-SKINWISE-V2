import 'package:flutter/material.dart';

// Main function to run the app
void main() {
  runApp(const MyApp());
}

// MyApp to set up the Material theme
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'History UI',
      theme: ThemeData(
        // Define a primary color so the TabBar indicator can use it
        primarySwatch: Colors.blue,
        // Set the primary color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF007BFF), // A strong blue
          primary: const Color(0xFF007BFF),
        ),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Inter', // A clean, modern font
      ),
      home: const HistoryInterface(), // Start with HistoryInterface
      debugShowCheckedModeBanner: false,
    );
  }
}

// --- Ito na yung HistoryInterface ---
// Ginagamit ang structure ng "Archive" pero kamukha ng image mo.

class HistoryInterface extends StatefulWidget {
  const HistoryInterface({super.key});

  @override
  State<HistoryInterface> createState() => _HistoryInterfaceState();
}

// Ginagamit ang TickerProviderStateMixin para sa TabController
class _HistoryInterfaceState extends State<HistoryInterface>
    with TickerProviderStateMixin {
  // Helper widget para sa list items (kinopya sa Archive example mo)
  // In-adjust ko lang yung colors para tumugma sa image
  Widget _buildHistoryItem({
    required String title,
    required String subtitle,
    required String date,
    bool isHighlighted = false,
  }) {
    // This logic creates the visual style from your image
    final Color backgroundColor =
    isHighlighted ? const Color(0xFFE0F7FA) : const Color(0xFFF0F0F0); // Light grey
    final Border? border = isHighlighted
        ? Border.all(color: const Color(0xFF007BFF), width: 1.5)
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.0),
        border: border,
      ),
      child: Row(
        children: [
          // The blue square
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              // Gamit ang primary blue color
              color: const Color(0xFF007BFF),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          const SizedBox(width: 16),
          // Column para sa text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600, // Semi-bold
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Kinukuha natin yung primary color galing sa theme
    final primaryColor = Theme.of(context).colorScheme.primary;

    return DefaultTabController(
      length: 2, // Two tabs: History and Archived
      initialIndex: 0, // Naka-set sa "History" tab
      child: Scaffold(
        backgroundColor: Colors.white,
        // 1. AppBar (kamukha ng navigation bar sa image)
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0, // Walang shadow
          // Back button
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              // Add navigation logic here, e.g.,
              // if (Navigator.canPop(context)) {
              //   Navigator.of(context).pop();
              // }
            },
          ),
        ),
        // 2. Body
        body: Column(
          children: [
            // 3. The TabBar (History / Archived)
            // Ito yung custom styling para magmukhang SegmentedControl
            Container(
              height: 40, // Height ng tabs
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white, // White background for the whole bar
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: primaryColor, width: 1.0),
              ),
              child: TabBar(
                // ===== ITO YUNG NAG-AAAYOS NG KULAY SA TAB =====
                indicator: BoxDecoration(
                  color: primaryColor, // Solid blue background for selected
                  borderRadius: BorderRadius.circular(7.0),
                ),
                // ===============================================
                labelColor: Colors.white, // Text color pag selected
                unselectedLabelColor: Colors.black, // Text color pag NOT selected
                tabs: const [
                  Tab(text: 'History'),
                  Tab(text: 'Archived'),
                ],
              ),
            ),

            // 4. The content for each tab
            Expanded(
              child: TabBarView(
                children: [
                  // *** HISTORY TAB CONTENT (Ito yung nasa screenshot) ***
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // "Saved" at "Rarity" Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Saved',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                // Rarity filter logic
                              },
                              icon: const Text(
                                'Rarity',
                                style: TextStyle(color: Colors.orange, fontSize: 14),
                              ),
                              label: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.orange,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // List ng items
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // Naka-highlight yung una, base sa "Archive" code mo
                                _buildHistoryItem(
                                  title: 'Acne',
                                  subtitle: 'Common',
                                  date: 'September 10, 2025',
                                  isHighlighted: true,
                                ),
                                _buildHistoryItem(
                                  title: 'Acne',
                                  subtitle: 'Common',
                                  date: 'September 10, 2025',
                                ),
                                _buildHistoryItem(
                                  title: 'Acne',
                                  subtitle: 'Common',
                                  date: 'September 10, 2025',
                                ),
                                // Naka-highlight din yung huli, base sa bago mong image
                                _buildHistoryItem(
                                  title: 'Acne',
                                  subtitle: 'Common',
                                  date: 'September 10, 2025',
                                  isHighlighted: true, // Pwede mo 'to palitan
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // *** ARCHIVED TAB CONTENT ***
                  const Center(
                    child: Text('Archived items will appear here'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}