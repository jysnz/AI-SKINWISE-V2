import 'package:flutter/material.dart';
import 'dart:math';
import 'AccountPage.dart';
import 'DiseasesPage.dart';

class DashboardContent extends StatefulWidget {
  final String firstName;
  final Map<String, dynamic>? userData;
  final VoidCallback onRefresh; // <--- NEW: Callback to refresh data

  const DashboardContent({
    super.key,
    required this.firstName,
    this.userData,
    required this.onRefresh, // <--- Require it
  });

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  int waterGlasses = 0;

  String _calculateBMI() {
    if (widget.userData == null) return "--";
    double height = double.tryParse(widget.userData!['Height'].toString()) ?? 0;
    double weight = double.tryParse(widget.userData!['Weight'].toString()) ?? 0;

    if (height <= 0 || weight <= 0) return "N/A";
    double heightInMeters = height / 100;
    double bmi = weight / (heightInMeters * heightInMeters);

    return bmi.toStringAsFixed(1);
  }

  String _getTimeBasedGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  final List<String> _skinTips = [
    "Drink at least 8 glasses of water for glowing skin.",
    "Always wear sunscreen, even on cloudy days!",
    "Wash your pillowcases weekly to prevent acne.",
    "Vitamin C serum helps brighten skin tone.",
    "Moisturize immediately after showering to lock in hydration."
  ];

  @override
  Widget build(BuildContext context) {
    String greeting = _getTimeBasedGreeting();
    String bmi = _calculateBMI();
    String dailyTip = _skinTips[DateTime.now().day % _skinTips.length];

    // Extract profile image URL directly from the passed userData
    String? profileImageUrl = widget.userData?['profile_image'];
    bool hasProfileImage = profileImageUrl != null && profileImageUrl.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. HEADER SECTION
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$greeting,",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      Text(
                        widget.firstName.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF005DA1)),
                      ),
                    ],
                  ),

                  // WRAPPED CIRCLE AVATAR
                  GestureDetector(
                    onTap: () async {
                      // Navigate to Account Page and WAIT for it to return
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AccountPage(userData: widget.userData),
                        ),
                      );

                      // When we come back, trigger the refresh!
                      widget.onRefresh();
                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: const Color(0xFF005DA1),
                      backgroundImage: hasProfileImage
                          ? NetworkImage(profileImageUrl!)
                          : null,
                      child: hasProfileImage
                          ? null
                          : Text(
                        widget.firstName.isNotEmpty
                            ? widget.firstName[0].toUpperCase()
                            : "U",
                        style: const TextStyle(
                            color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // 2. HEALTH SUMMARY CARD (BMI)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF005DA1), Color(0xFF0083E0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5))
                  ],
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Health Overview",
                            style: TextStyle(
                                color: Colors.white70, fontSize: 14)),
                        const SizedBox(height: 5),
                        Text("BMI Score: $bmi",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        const Text("Based on your profile data",
                            style: TextStyle(
                                color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.favorite, color: Colors.white, size: 40),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // 3. QUICK ACTIONS (Updated with Diseases Button)
              const Text("Quick Actions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Row(
                children: [
                  // New Scan Button
                  Expanded(
                    child: _buildActionCard(
                      icon: Icons.camera_alt_outlined,
                      title: "New Scan",
                      color: Colors.orange.shade50,
                      iconColor: Colors.orange,
                      onTap: () {
                        print("Go to scanner");
                      },
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Diseases Covered Button (NEW)
                  Expanded(
                    child: _buildActionCard(
                      icon: Icons.medical_services_outlined,
                      title: "Diseases",
                      color: Colors.blue.shade50,
                      iconColor: Colors.blue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SkinDiseasesPage(),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 10),

                  // History Button
                  Expanded(
                    child: _buildActionCard(
                      icon: Icons.history,
                      title: "History",
                      color: Colors.purple.shade50,
                      iconColor: Colors.purple,
                      onTap: () {
                        print("Go to history");
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // 4. HYDRATION TRACKER
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Skin Hydration",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text("$waterGlasses / 8 Cups",
                            style: const TextStyle(
                                color: Color(0xFF005DA1),
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(8, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (index < waterGlasses) {
                                waterGlasses = index;
                              } else {
                                waterGlasses = index + 1;
                              }
                            });
                          },
                          child: Icon(
                            index < waterGlasses
                                ? Icons.water_drop
                                : Icons.water_drop_outlined,
                            color: index < waterGlasses
                                ? Colors.blue
                                : Colors.grey[300],
                            size: 30,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // 5. DAILY TIP
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF7FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb,
                            color: Colors.orange[700], size: 20),
                        const SizedBox(width: 8),
                        Text("Daily Skin Tip",
                            style: TextStyle(
                                color: Colors.orange[800],
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      dailyTip,
                      style: TextStyle(
                          color: Colors.grey[800], fontSize: 14, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(
      {required IconData icon,
        required String title,
        required Color color,
        required Color iconColor,
        required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 8),
            Text(title,
                style: TextStyle(
                    color: iconColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
          ],
        ),
      ),
    );
  }
}