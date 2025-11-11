import 'package:flutter/material.dart';

// Ang class name ay "Archive"
class Archive extends StatefulWidget {
  const Archive({super.key});

  @override
  State<Archive> createState() => _ArchiveState();
}

// ===== ITO ANG FIX (with TickerProviderStateMixin) =====
class _ArchiveState extends State<Archive> with TickerProviderStateMixin {
  // Para sa state ng custom bottom nav
  int _navIndex = 3; // 3 = History (para ma-highlight)

  // Helper widget to build the list items
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
        color: isHighlighted ? Color(0xFFE0F7FA) : Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
        border: isHighlighted
            ? Border.all(color: Color(0xFF007BFF), width: 1.5)
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xFF1877F2),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
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

  // ===== ITO ANG CUSTOM WIDGET PARA SA NAV BAR =====
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
              : BoxDecoration(),
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
  // ====================================================

  @override
  Widget build(BuildContext context) {
    // Kinukuha natin yung primary color galing sa theme
    // Siguraduhin na ang primary color sa main.dart theme ay tama
    final primaryColor = Theme.of(context).colorScheme.primary;

    return DefaultTabController(
      length: 2, // Two tabs: History and Archived
      initialIndex: 0, // Naka-set sa "History" tab
      child: Scaffold(
        backgroundColor: Colors.white,
        // 1. AppBar
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        // 2. Body
        body: Column(
          children: [
            // 3. The TabBar (History / Archived)
            Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 15.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TabBar(
                indicatorPadding: EdgeInsets.symmetric(horizontal: -80, vertical: 4.0),
                // ===== ITO YUNG NAG-AAAYOS NG KULAY SA TAB =====
                indicator: BoxDecoration(
                  color: primaryColor, // Solid blue background
                  borderRadius: BorderRadius.circular(8.0),
                ),
                // ===============================================
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: [
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Saved',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {},
                              icon: Text(
                                'Rarity',
                                style: TextStyle(color: Colors.orange),
                              ),
                              label: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
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

                  // *** ARCHIVED TAB CONTENT ***
                  Center(
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