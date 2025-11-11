import 'package:flutter/material.dart';

class Rarity extends StatefulWidget {
  const Rarity({super.key});

  @override
  State<Rarity> createState() => _RarityState();
}

class _RarityState extends State<Rarity> with TickerProviderStateMixin {
  String _selectedRarity = 'All';
  int _navIndex = 3; // Highlight "History"

  Widget _buildHistoryItem({
    required String title,
    required String subtitle,
    required String date,
    bool isHighlighted = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: isHighlighted ? const Color(0xFFE0F7FA) : Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
        border: isHighlighted
            ? Border.all(color: const Color(0xFF007BFF), width: 1.5)
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF1877F2),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
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
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, String label, int index, Color primaryColor) {
    final bool isSelected = (_navIndex == index);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _navIndex = index;
            // TODO: Add navigation logic here
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: isSelected
              ? BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(12.0),
          )
              : const BoxDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Column(
          children: [
            // ==== TAB BAR ====
            Container(
              height: 48,
              margin: const EdgeInsets.symmetric(horizontal: 6.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding:
                const EdgeInsets.symmetric(horizontal: -80.0, vertical: 4.0),
                indicator: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: const [
                  Tab(text: 'History'),
                  Tab(text: 'Archived'),
                ],
              ),
            ),

            // ==== TAB CONTENT ====
            Expanded(
              child: TabBarView(
                children: [
                  // --- HISTORY TAB ---
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // "Saved" + "Rarity" Row
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
                            PopupMenuButton<String>(
                              onSelected: (String value) {
                                setState(() {
                                  _selectedRarity = value;
                                });
                              },
                              itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: 'All',
                                  child: Text('All'),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'Common',
                                  child: Text('Common'),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'Uncommon',
                                  child: Text('Uncommon'),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'Rare',
                                  child: Text('Rare'),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'Very Rare',
                                  child: Text('Very Rare'),
                                ),
                              ],
                              child: Row(
                                children: const [
                                  Text(
                                    'Rarity',
                                    style: TextStyle(color: Colors.orange),
                                  ),
                                  Icon(Icons.arrow_drop_down,
                                      color: Colors.orange),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // ==== LIST ====
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
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
                                _buildHistoryItem(
                                  title: 'Acne',
                                  subtitle: 'Common',
                                  date: 'September 10, 2025',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- ARCHIVED TAB ---
                  const Center(
                    child: Text('Archived items will appear here'),
                  ),
                ],
              ),
            ),
          ],
        ),

        // ==== BOTTOM NAV ====
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_filled, 'Home', 0, primaryColor),
              _buildNavItem(Icons.qr_code_scanner, 'Scanner', 1, primaryColor),
              _buildNavItem(Icons.message, 'Message', 2, primaryColor),
              _buildNavItem(Icons.history, 'History', 3, primaryColor),
            ],
          ),
        ),
      ),
    );
  }
}
