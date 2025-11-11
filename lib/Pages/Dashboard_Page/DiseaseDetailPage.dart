// File: DiseaseDetailPage.dart

import 'package:flutter/material.dart';

class DiseaseDetailPage extends StatefulWidget {
  final String name;
  final String rarity;

  const DiseaseDetailPage({
    Key? key,
    required this.name,
    required this.rarity,
  }) : super(key: key);

  @override
  State<DiseaseDetailPage> createState() => _DiseaseDetailPageState();
}

class _DiseaseDetailPageState extends State<DiseaseDetailPage> {
  // --- STATE FOR IMAGE CAROUSEL ---
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // --- DUMMY DATA FOR IMAGES ---
  final List<Widget> _imagePlaceholders = [
    _buildImagePlaceholder(Colors.red[100]!, Icons.image_outlined),
    _buildImagePlaceholder(Colors.blue[100]!, Icons.image_search),
    _buildImagePlaceholder(Colors.green[100]!, Icons.broken_image_outlined),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // --- HELPER WIDGET FOR DUMMY IMAGES ---
  static Widget _buildImagePlaceholder(Color color, IconData icon) {
    return Container(
      color: color,
      child: Center(
        child: Icon(
          icon,
          size: 100,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  // --- HELPER METHOD TO BUILD DOT INDICATORS ---
  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _imagePlaceholders.length; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  // --- HELPER WIDGET FOR A SINGLE DOT ---
  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF005DA1) : Colors.grey[400],
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This is the long description text
    const String description =
        'A common skin condition that occurs when hair follicles '
        'become clogged with oil, dead skin cells, and bacteria. It '
        'often appears on the face, chest, back, and shoulders and '
        'can range from mild to severe.\n\n'
        'Types of Lesions:\n'
        'Whiteheads (Closed Comedones): Small, flesh-colored '
        'bumps caused by clogged pores.\n'
        'Blackheads (Open Comedones): Dark, open pores filled '
        'with excess oil and dead skin.\n'
        'Papules: Small, red, inflamed bumps that may feel tender.\n'
        'Pustules (Pimples): Red bumps with pus at the tip.\n'
        'Nodules: Large, painful lumps deep under the skin.\n'
        'Cysts: Painful, pus-filled lumps that can cause scarring.';

    return Scaffold(
      appBar: AppBar(
        leading: TextButton.icon(
          icon: const Icon(
            Icons.arrow_back,
            size: 28.0,
          ),
          label: const Text('Back'),
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        leadingWidth: 110.0,
        title: const Text(''),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1, // Note: The AppBar's elevation already creates a line.
        // The Divider below adds another one.
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // --- ✅ DIVIDER ADDED HERE ---
            // This divider is separate from the AppBar's elevation shadow
            const Divider(height: 1, thickness: 1),
            // --- ✅ END OF CHANGE ---
            const SizedBox(height: 16.0),
            // --- IMAGE CAROUSEL ---
            SizedBox(
              height: 300,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding around photo
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16), // Round edges
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _imagePlaceholders.length,
                        itemBuilder: (context, index) {
                          return _imagePlaceholders[index];
                        },
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- DOT INDICATORS ---
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(),
            ),
            const SizedBox(height: 16.0), // Spacing after dots

            // 2. Main Content Area (for text above tiles)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Disease Name
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF005DA1),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Rarity
                  Text(
                    widget.rarity,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            const SizedBox(height: 8.0), // Spacing between rarity and first tile


            // 3. Expandable Sections
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: Colors.grey, // Border color
                    width: 1.0,           // Border width
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // --- DESCRIPTION TILE ---
                    ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
                      iconColor: Colors.grey[700],
                      collapsedIconColor: Colors.grey[700],
                      title: const Text(
                        'Description',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                          child: Text(
                            description,
                            style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black54),
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16, color: Colors.grey), // Kept this divider

                    // --- SYMPTOMS TILE ---
                    ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
                      iconColor: Colors.grey[700],
                      collapsedIconColor: Colors.grey[700],
                      title: const Text(
                        'Symptoms',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      children: const [
                        ListTile(
                          title: Text('• Symptom 1...', style: TextStyle(color: Colors.black54)),
                          dense: true,
                        ),
                        ListTile(
                          title: Text('• Symptom 2...', style: TextStyle(color: Colors.black54)),
                          dense: true,
                        ),
                      ],
                    ),

                    const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16, color: Colors.grey), // Kept this divider

                    // --- REMEDIES TILE ---
                    ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
                      iconColor: Colors.grey[700],
                      collapsedIconColor: Colors.grey[700],
                      title: const Text(
                        'Remedies',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      children: const [
                        ListTile(
                          title: Text('• Remedy 1...', style: TextStyle(color: Colors.black54)),
                          dense: true,
                        ),
                        ListTile(
                          title: Text('• Remedy 2...', style: TextStyle(color: Colors.black54)),
                          dense: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0), // Spacing at the bottom
          ],
        ),
      ),
    );
  }
}