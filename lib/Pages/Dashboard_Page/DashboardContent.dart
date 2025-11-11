// File: dashboard/DashboardContent.dart

import 'package:flutter/material.dart';
import 'AccountPage.dart';
import 'DiseaseDetailPage.dart';

class DashboardContent extends StatefulWidget {
  DashboardContent({Key? key}) : super(key: key);

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {

  // --- STATE VARIABLES ---

  List<Map<String, String>> _masterDiseaseList = []; // Holds all data from DB
  List<Map<String, String>> _filteredDiseaseList = []; // Holds the displayed data
  bool _isLoading = true;

  final List<String> _rarityOptions = ['All', 'Common', 'Uncommon', 'Rare', 'Very Rare'];
  String _selectedRarity = 'All';

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchActive = false;


  @override
  void initState() {
    super.initState();
    _fetchDiseasesFromDatabase();

    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchActive = _searchFocusNode.hasFocus;
      });
    });

    _searchController.addListener(() {
      _filterList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _fetchDiseasesFromDatabase() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network call

    final List<Map<String, String>> dataFromDb = [
      {'name': 'Acne', 'rarity': 'Common'},
      {'name': 'Eczema', 'rarity': 'Common'},
      {'name': 'Psoriasis', 'rarity': 'Uncommon'},
      {'name': 'Rosacea', 'rarity': 'Common'},
      {'name': 'Melanoma', 'rarity': 'Rare'},
      {'name': 'Hives', 'rarity': 'Uncommon'},
      {'name': 'Dermatitis', 'rarity': 'Common'},
      {'name': 'Vitiligo', 'rarity': 'Very Rare'},
    ];

    if (mounted) {
      setState(() {
        _masterDiseaseList = dataFromDb;
        _filteredDiseaseList = dataFromDb; // Initially, show all
        _isLoading = false;
      });
    }
  }

  void _filterList() {
    final String query = _searchController.text.toLowerCase();

    List<Map<String, String>> filteredList = _masterDiseaseList;

    if (_selectedRarity != 'All') {
      filteredList = filteredList.where((disease) {
        return disease['rarity'] == _selectedRarity;
      }).toList();
    }

    if (query.isNotEmpty) {
      filteredList = filteredList.where((disease) {
        return disease['name']!.toLowerCase().contains(query);
      }).toList();
    }

    setState(() {
      _filteredDiseaseList = filteredList;
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 1. Custom Header (Profile)
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AccountPage()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Icon(Icons.account_circle_outlined, size: 60, color: Color(0xFF005DA1)),
                    const SizedBox(width: 12),
                    const Text(
                      'Guest',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            // Line between Guest and Search Bar ✅
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Divider(
                thickness: 1,
                height: 1,
                color: Colors.grey[300],
              ),
            ),



            // 2. Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 20.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: _isSearchActive ? Color(0xFF005DA1) : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Color(0xFF005DA1),
                        width: 2.0,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
              ),
            ),

            // 3. Section Header (Rarity Dropdown)
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Discovered Skin Diseases',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  // --- MODIFIED: Replaced Dropdown with PopupMenuButton for precise layout ---
                  PopupMenuButton<String>(

                    // --- NEW 1: Adjusts the pop-up location ---
                    // (dx, dy) - 0 horizontal, 40 pixels down
                    offset: const Offset(0, 30),

                    // --- NEW 2: Adjusts the menu's width ---
                    constraints: const BoxConstraints(
                      minWidth: 160, // Forces menu to be at least 160px wide
                    ),

                    // This builds the "Rarity" button
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0), //Gives it some tap space
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Rarity', // This is now a static label
                            style: TextStyle(
                              color: Colors.orange[700],
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Icon(Icons.arrow_drop_down, color: Colors.orange[700]),
                        ],
                      ),
                    ),

                    onSelected: (String newValue) {
                      setState(() {
                        _selectedRarity = newValue;
                      });
                      _filterList();
                    },

                    // These properties style the menu itself
                    color: const Color(0xFF005DA1), // Blue background
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),

                    // This builds the list of items
                    itemBuilder: (BuildContext context) {
                      return _rarityOptions.map((String value) {
                        bool isSelected = (_selectedRarity == value);

                        return PopupMenuItem<String>(
                          value: value,
                          padding: EdgeInsets.zero,
                          child: Container(
                            width: double.infinity,
                            // ✅ Margin pushes the selected highlight inward
                            margin: EdgeInsets.symmetric(
                              horizontal: isSelected ? 8.0 : 0.0,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              value,
                              style: TextStyle(
                                color: isSelected ? Color(0xFF005DA1) : Colors.white,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),

                        );

                      }).toList();
                    },
                  ),
                ], // <-- This bracket closes the Row's children
              ), // <-- This parenthesis closes the Row
            ), // <-- This parenthesis closes the Padding

            // 4. List of Diseases
            Container(
              child: _isLoading
                  ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              )
                  : _filteredDiseaseList.isEmpty
                  ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('No diseases found.'),
                ),
              )
                  : ListView.builder(
                itemCount: _filteredDiseaseList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final disease = _filteredDiseaseList[index];
                  return DiseaseCard(
                    name: disease['name']!,
                    rarity: disease['rarity']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// 5. Reusable Card Widget - No changes needed
class DiseaseCard extends StatelessWidget {
  final String name;
  final String rarity;

  const DiseaseCard({
    Key? key,
    required this.name,
    required this.rarity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF005DA1),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    rarity,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              // --- 2. UPDATE THIS onPressed FUNCTION ---
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DiseaseDetailPage(
                      name: name,
                      rarity: rarity,
                    ),
                  ),
                );
              },
              child: const Text(
                'View more',
                style: TextStyle(color: Color(0xFF005DA1)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}