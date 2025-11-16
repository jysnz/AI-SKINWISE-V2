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
  final String imageUrl; // Updated to receive a single URL string
  final String description;
  final String symptoms;
  final String remedies;
  final String references;

  const DiseaseDetailPage({
    Key? key,
    required this.name,
    required this.rarity,
    this.imageUrl = '',
    this.description = 'No description provided.',
    this.symptoms = 'No symptoms listed.',
    this.remedies = 'No remedies listed.',
    this.references = '',
  }) : super(key: key);

  @override
  State<DiseaseDetailPage> createState() => _DiseaseDetailPageState();
}

class _DiseaseDetailPageState extends State<DiseaseDetailPage> {

  // We will build the panels dynamically in the build method
  // to ensure they use the latest widget data.

  // --- WIDGET BUILDERS ---

  Widget _buildImagePlaceholder(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity, // Ensure it takes full width
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      clipBehavior: Clip.hardEdge, // Ensures image respects the rounded corners
      child: widget.imageUrl.isNotEmpty
          ? Image.network(
        widget.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.broken_image, size: 50, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Text("Image not found", style: TextStyle(color: Colors.grey[600])),
            ],
          );
        },
      )
          : Center(
        child: Icon(
          Icons.image,
          size: 100,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  Widget _buildExpansionTiles() {
    // Create the list dynamically based on passed data
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
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1.0,
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
        children: List.generate(panels.length, (index) {
          final item = panels[index];
          return Column(
            children: [
              ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
                iconColor: Colors.grey[700],
                collapsedIconColor: Colors.grey[700],
                title: Text(
                  item.header,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item.body,
                        style: const TextStyle(
                            fontSize: 16, height: 1.5, color: Colors.black54),
                      ),
                    ),
                  ),
                ],
              ),
              if (index < panels.length - 1)
                Divider(
                    height: 1,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                    color: Colors.grey[300]),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildReferencesSection(BuildContext context) {
    if (widget.references.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'References',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[50],
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              children: [
                // We display the reference string directly.
                // If you have multiple links separated by commas in your DB,
                // you would need to split them here.
                // For now, we treat it as one main reference source.
                _buildReferenceTile(
                  context,
                  widget.references, // The URL
                  'Tap to view source', // Title
                  widget.references, // Subtitle (The URL itself)
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
      // Basic check to see if it looks like a URL
      if (!url.startsWith('http')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid URL provided in database')),
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
            SnackBar(content: Text('Could not launch $url')),
          );
        }
      }
    }

    return ListTile(
      leading: Icon(
        Icons.article_outlined,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
      trailing: Icon(Icons.open_in_new_outlined,
          size: 20, color: Colors.grey[500]),
      onTap: launchUrlInExternalApp,
      contentPadding:
      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton.icon(
          icon: const Icon(
            Icons.arrow_back,
            size: 28.0,
            color: Colors.black,
          ),
          label: const Text(
            'Back',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        leadingWidth: 110.0,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(height: 1, thickness: 1),
            const SizedBox(height: 16.0),

            // Image
            _buildImagePlaceholder(context),

            const SizedBox(height: 20.0),

            // Main Content Area: Title and Rarity
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
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // Expandable Sections
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildExpansionTiles(),
            ),
            const SizedBox(height: 24.0),

            // References Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildReferencesSection(context),
            ),

            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }
}