import 'package:flutter/material.dart';
import 'DiseaseDetailPage.dart'; // Import the detail page

class SkinDiseasesPage extends StatelessWidget {
  const SkinDiseasesPage({super.key});

  final List<Map<String, String>> _diseases = const [
    {
      "name": "Acne Vulgaris",
      "description": "Common skin condition that happens when hair follicles become plugged with oil and dead skin cells."
    },
    {
      "name": "Melanoma",
      "description": "The most serious type of skin cancer, often developing in the cells (melanocytes) that produce melanin."
    },
    {
      "name": "Atopic Dermatitis",
      "description": "A condition that makes your skin red and itchy. It's common in children but can occur at any age."
    },
    {
      "name": "Psoriasis",
      "description": "A skin disease that causes a rash with itchy, scaly patches, most commonly on the knees, elbows, trunk and scalp."
    },
    {
      "name": "Seborrheic Keratosis",
      "description": "A noncancerous skin growth that usually appears as a waxy brown, black, or tan growth."
    },
    {
      "name": "Basal Cell Carcinoma",
      "description": "A type of skin cancer. Basal cell carcinoma begins in the basal cells — a type of cell within the skin that produces new skin cells."
    },
    {
      "name": "Ringworm",
      "description": "A rash caused by a fungal infection. It's usually a red, itchy, circular rash with clearer skin in the middle."
    },
    {
      "name": "Rosacea",
      "description": "A condition that causes blushing or flushing and visible blood vessels in your face."
    },
    {
      "name": "Actinic Keratosis",
      "description": "A rough, scaly patch on the skin caused by years of sun exposure."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Supported Diseases",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: _diseases.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 Columns like Dashboard
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 0.85, // Taller cards to fit text
          ),
          itemBuilder: (context, index) {
            final disease = _diseases[index];
            return _buildDiseaseCard(context, disease);
          },
        ),
      ),
    );
  }

  Widget _buildDiseaseCard(BuildContext context, Map<String, String> disease) {
    return GestureDetector(
      onTap: () {
        // Navigate to Detail Page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiseaseDetailPage(
              name: disease["name"]!,
              rarity: disease["rarity"]!,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. Icon Circle
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFEDF7FF), // Light Blue Background
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.healing, // You can change this icon per disease if you want
                color: Color(0xFF005DA1),
                size: 32,
              ),
            ),

            const SizedBox(height: 16),

            // 2. Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                disease["name"]!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 8),

            // 3. "View Details" text
            Text(
              "View Details",
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}