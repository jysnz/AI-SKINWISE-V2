import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'AccountPage.dart';
import 'DiseaseDetailPage.dart';

class DashboardContent extends StatefulWidget {
  DashboardContent({Key? key}) : super(key: key);

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  // --- STATE VARIABLES ---
  List<Map<String, dynamic>> _masterDiseaseList = [];
  List<Map<String, dynamic>> _filteredDiseaseList = [];
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

  // --- FETCH DATA FROM SUPABASE ---
  Future<void> _fetchDiseasesFromDatabase() async {
    try {
      debugPrint('Attempting to fetch from table: skinDiseases...');

      // Selects all columns from the table
      final response = await Supabase.instance.client
          .from('SkinDiseases')
          .select();

      debugPrint('Raw Supabase Response: $response');

      final List<Map<String, dynamic>> formattedData = (response as List).map((item) {
        return {
          // MAPPING: Database Column -> App Variable
          'name': item['disease_name'] ?? 'Unknown Name',
          'rarity': item['rarity'] ?? 'Unknown',
          'image': item['image_sample_url'] ?? '', // Gets the URL
          'description': item['description'] ?? 'No description available.',
          'symptoms': item['symptoms'] ?? '',
          'remedies': item['remedies'] ?? '',
          'references': item['references'] ?? '',
        };
      }).toList();

      if (mounted) {
        setState(() {
          _masterDiseaseList = formattedData;
          _filteredDiseaseList = formattedData;
          _isLoading = false;
        });
        debugPrint('Data loaded successfully: ${_masterDiseaseList.length} items.');
      }
    } catch (e) {
      debugPrint('CRITICAL ERROR fetching data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _filterList() {
    final String query = _searchController.text.toLowerCase();

    List<Map<String, dynamic>> filteredList = _masterDiseaseList;

    if (_selectedRarity != 'All') {
      filteredList = filteredList.where((disease) {
        return disease['rarity'].toString().toLowerCase() == _selectedRarity.toLowerCase();
      }).toList();
    }

    if (query.isNotEmpty) {
      filteredList = filteredList.where((disease) {
        return disease['name'].toString().toLowerCase().contains(query);
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
            // 1. Custom Header
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Divider(thickness: 1, height: 1, color: Colors.grey[300]),
            ),

            // 2. Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 20.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0)),
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
                      borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Color(0xFF005DA1), width: 2.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
              ),
            ),

            // 3. Filter Dropdown
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Discovered Skin Diseases',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  PopupMenuButton<String>(
                    offset: const Offset(0, 30),
                    constraints: const BoxConstraints(minWidth: 160),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Rarity',
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
                    color: const Color(0xFF005DA1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    itemBuilder: (BuildContext context) {
                      return _rarityOptions.map((String value) {
                        bool isSelected = (_selectedRarity == value);
                        return PopupMenuItem<String>(
                          value: value,
                          padding: EdgeInsets.zero,
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: isSelected ? 8.0 : 0.0),
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
                ],
              ),
            ),

            // 4. List View
            Container(
              child: _isLoading
                  ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              )
                  : _filteredDiseaseList.isEmpty
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: const [
                      Icon(Icons.inbox, size: 40, color: Colors.grey),
                      SizedBox(height: 10),
                      Text('No diseases found or Database Empty.'),
                    ],
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: _filteredDiseaseList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final disease = _filteredDiseaseList[index];
                  return DiseaseCard(
                    name: disease['name'],
                    rarity: disease['rarity'],
                    imageUrl: disease['image'],
                    fullData: disease,
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

// --- REUSABLE CARD WIDGET ---
class DiseaseCard extends StatelessWidget {
  final String name;
  final String rarity;
  final String imageUrl;
  final Map<String, dynamic> fullData;

  const DiseaseCard({
    Key? key,
    required this.name,
    required this.rarity,
    required this.imageUrl,
    required this.fullData,
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
            // --- IMAGE DISPLAY ---
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF005DA1),
                borderRadius: BorderRadius.circular(10.0),
              ),
              clipBehavior: Clip.hardEdge,
              child: imageUrl.isNotEmpty
                  ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, color: Colors.white);
                },
              )
                  : const Icon(Icons.medical_services, color: Colors.white),
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
              onPressed: () {
                // Navigate to Detail Page
                // NOTE: Ensure your DiseaseDetailPage constructor accepts these arguments!
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DiseaseDetailPage(
                      name: name,
                      rarity: rarity,
                      // Uncomment these if your Detail page accepts them:
                      // description: fullData['description'],
                      // imageUrl: imageUrl,
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