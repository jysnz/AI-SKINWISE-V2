import 'dart:io';
import 'package:ai_skinwise_v2/Pages/Clinic%20Page/Freemess.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Detectioninformation extends StatefulWidget {
  final List<String> imagePaths;
  final String userSymptoms;

  const Detectioninformation({
    super.key,
    this.imagePaths = const [],
    required this.userSymptoms,
  });
  // --- END MODIFIED ---

  @override
  State<Detectioninformation> createState() => _DetectioninformationState();
}

class _DetectioninformationState extends State<Detectioninformation> {
  int _openPanelIndex = -1;

  final List<PanelItem> _panels = [
    PanelItem(header: "Description", body: "Description of Acne"),
    PanelItem(
      header: 'Symptoms',
      body:
          '• Whiteheads (Closed Comedones)\n• Blackheads (Open Comedones)\n• Papules: Small, red, inflamed bumps\n• Pustules (Pimples)\n• Nodules: Large, painful lumps\n• Cysts: Painful, pus-filled lumps',
    ),
    PanelItem(
      header: 'Remedies',
      body:
          '• Over-the-counter (OTC) treatments: Benzoyl peroxide, Salicylic acid, Adapalene.\n• Prescription medications: Retinoids, Antibiotics.\n• Lifestyle: Gently wash face, avoid touching face, shampoo hair regularly.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    print("User symptoms from scanner: ${widget.userSymptoms}");
    return Scaffold(
      appBar: AppBar(
        // --- MODIFIED ---
        // Show back button if we have images
        leading:
            widget.imagePaths.isNotEmpty
                ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    // Navigate back to the home route
                    Navigator.of(context).pushReplacementNamed('/home');
                  },
                )
                : null,
        // --- END MODIFIED ---
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- MODIFIED ---
            // Conditionally show the image carousel or the placeholder
            (widget.imagePaths.isNotEmpty)
                ? _ImageCarousel(imagePaths: widget.imagePaths) // NEW WIDGET
                : _buildImagePlaceholder(),
            // --- END MODIFIED ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Acne',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Common',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // const SizedBox(height: 16),
                  // _buildDescriptionText(),
                  const SizedBox(height: 24),
                  _buildExpansionPanels(),
                  const SizedBox(height: 24),
                  _buildActionButtons(),
                  const SizedBox(height: 24),
                  _buildReferencesSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // This widget is unchanged
  Widget _buildImagePlaceholder() {
    return Container(
      height: 250,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Center(
        child: Icon(Icons.image, size: 100, color: Colors.grey[400]),
      ),
    );
  }

  Widget _buildExpansionPanels() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          // --- CORRECTED LOGIC ---
          if (isExpanded) {
            _openPanelIndex = index; // Set this panel as the open one
          } else {
            _openPanelIndex = -1; // Close the panel
          }
          // --- END CORRECTION ---
        });
      },
      elevation: 1,
      dividerColor: Colors.grey[300],
      children:
          _panels.map((item) {
            int panelIndex = _panels.indexOf(item);
            return ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(
                    item.header,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
              body: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(
                  item.body,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
              isExpanded:
                  _openPanelIndex ==
                  panelIndex, // This part was already correct
              canTapOnHeader: true,
            );
          }).toList(),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.search, color: Colors.white),
            label: const Text(
              'Find Nearest Clinic',
              style: TextStyle(
                color: Color.fromARGB(255, 248, 201, 201),
                fontSize: 16,
              ),
            ),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => const Freemess()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: Icon(
                  Icons.save_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: Text(
                  'Save',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
                onPressed: () {
                  // Handle save
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE6F2FF), // Light blue
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                icon: Icon(
                  Icons.camera_alt_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: Text(
                  'Scan New',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/scanner');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE6F2FF), // Light blue
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReferencesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'References',
          style: TextStyle(
            fontSize: 20, // Slightly larger title
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        // A container to group the links with a light background and border
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[50],
            border: Border.all(color: Colors.grey[200]!),
          ),
          // Use ClipRRect to ensure the ListTile's ripple effect
          // respects the container's rounded corners
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              children: [
                _buildReferenceTile(
                  'https://www.aad.org/public/diseases/acne',
                  'American Academy of Dermatology: Acne',
                  'aad.org',
                ),
                Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: Colors.grey[200],
                ),
                _buildReferenceTile(
                  'https://www.mayoclinic.org/diseases-conditions/acne/symptoms-causes/syc-20368047',
                  'Mayo Clinic: Acne Symptoms & Causes',
                  'mayoclinic.org',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReferenceTile(String url, String title, String subtitle) {
    // The URL launching logic is now inside the tile builder
    Future<void> _launchUrl() async {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Could not launch $url')));
        }
      }
    }

    return ListTile(
      leading: Icon(
        Icons.article_outlined, // A more "document" focused icon
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600], fontSize: 14),
      ),
      trailing: Icon(
        Icons.open_in_new_outlined,
        size: 20,
        color: Colors.grey[500],
      ),
      onTap: _launchUrl,
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    );
  }
}

// Helper class for Expansion Panel data
class PanelItem {
  final String header;
  final String body;

  PanelItem({required this.header, required this.body});
}

// --- NEW WIDGET ---
// A stateful widget for the image carousel
class _ImageCarousel extends StatefulWidget {
  final List<String> imagePaths;
  const _ImageCarousel({required this.imagePaths});

  @override
  State<_ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<_ImageCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280, // Height for image + dots
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          // Image PageView
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.imagePaths.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Image.file(
                    File(widget.imagePaths[index]),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
                },
              ),
            ),
          ),
          // Dots Indicator
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.imagePaths.length,
              (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _currentPage == index
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[300],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
