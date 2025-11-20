import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Helper class for Expansion Panel data
class PanelItem {
  final String header;
  final String body;

  PanelItem({
    required this.header,
    required this.body,
  });
}

class DiseaseDetailPage extends StatefulWidget {
  final String name;
  final String rarity;
  final String imageUrl;
  final String description;
  final String symptoms;
  final String remedies;
  final String references;

  const DiseaseDetailPage({
    required this.name,
    required this.rarity,
    this.imageUrl = '',
    this.description = 'No description provided.',
    this.symptoms = 'No symptoms listed.',
    this.remedies = 'No remedies listed.',
    this.references = '',
  });

  @override
  State<DiseaseDetailPage> createState() => _DiseaseDetailPageState();
}

class _DiseaseDetailPageState extends State<DiseaseDetailPage> {
  // Define the primary brand color for consistency
  final Color _primaryColor = const Color(0xFF005DA1);

  // --- WIDGET BUILDERS ---

  Widget _buildImagePlaceholder(BuildContext context) {
    return Container(
      height: 240, // Slightly reduced for better proportion
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20), // Softer corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: widget.imageUrl.isNotEmpty
          ? Image.network(
        widget.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_not_supported_outlined,
                  size: 48, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Text("Image unavailable",
                  style:
                  TextStyle(color: Colors.grey[500], fontSize: 12)),
            ],
          );
        },
      )
          : Center(
        child: Icon(
          Icons.medical_services_outlined,
          size: 60,
          color: _primaryColor.withOpacity(0.2),
        ),
      ),
    );
  }

  Widget _buildExpansionTiles() {
    final List<PanelItem> panels = [
      PanelItem(
        header: "Description",
        body: widget.description,
      ),
      PanelItem(
        header: 'Symptoms',
        body: widget.symptoms,
      ),
      PanelItem(
        header: 'Remedies',
        body: widget.remedies,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        // Cleaner, subtle border
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1.0,
        ),
        // Softer shadow for depth
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF005DA1).withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Column(
          children: List.generate(panels.length, (index) {
            final item = panels[index];
            return Column(
              children: [
                Theme(
                  // Remove default divider lines from ExpansionTile
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 6.0),
                    iconColor: _primaryColor,
                    collapsedIconColor: Colors.grey[600],
                    backgroundColor: Colors.grey[50], // Subtle highlight when open
                    title: Text(
                      item.header,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800]),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 24.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item.body,
                            style: TextStyle(
                                fontSize: 15,
                                height: 1.6, // Better line height for reading
                                color: Colors.blueGrey[700]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (index < panels.length - 1)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.grey[100],
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildReferencesSection(BuildContext context) {
    if (widget.references.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4.0, bottom: 12.0),
          child: Text(
            'References',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: [
                _buildReferenceTile(
                  context,
                  widget.references,
                  'Scientific Source',
                  widget.references,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReferenceTile(
      BuildContext context, String url, String title, String subtitle) {
    Future<void> launchUrlInExternalApp() async {
      if (!url.startsWith('http')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid URL provided')),
        );
        return;
      }

      final Uri uri = Uri.parse(url);
      try {
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          throw 'Could not launch';
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch source')),
          );
        }
      }
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: launchUrlInExternalApp,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.link,
                  color: _primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.blueGrey[400],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Slightly off-white background
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          color: Colors.black87,
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Disease Details",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            _buildImagePlaceholder(context),

            const SizedBox(height: 10.0),

            // Title and Rarity Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Disease Name
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF005DA1),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Rarity Badge (Converted text to a Chip)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF005DA1).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.rarity,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF005DA1),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30.0),

            // Expandable Sections
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildExpansionTiles(),
            ),

            const SizedBox(height: 30.0),

            // References Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildReferencesSection(context),
            ),
          ],
        ),
      ),
    );
  }
}