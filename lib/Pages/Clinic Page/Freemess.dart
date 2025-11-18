import 'package:flutter/material.dart';

// --- GLOBAL CONSTANTS ---
const Color _kPrimaryBlue = Color(0xFF1976D2);
const Color _kDarkGrey = Color(0xFF333333);

class Freemess extends StatefulWidget {
  const Freemess({super.key});

  @override
  State<Freemess> createState() => _FreemessState();
}

class _FreemessState extends State<Freemess> {
  // Placeholder Data
  final String _clinicImageUrl =
      'https://cdn.pixabay.com/photo/2014/11/27/20/12/doctor-548133_1280.jpg';

  // --- FUNCTION TO SHOW THE DIALOG (MESSAGING MODAL) ---
  void _showFreeMessageDialog(BuildContext context) {
    // Local state variables for inputs
    String age = '';
    String birthDate = '';
    String gender = '';
    TextEditingController concernController = TextEditingController();

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateSB) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title Bar (Message Free)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Message',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Free',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, thickness: 1, color: Colors.grey),

                    // Input Fields Content
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Labels: Age, Birth Date, Gender
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Expanded(
                                child: Text(
                                  'Age',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Birth Date',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Gender',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Age, Birth Date, Gender Input Fields Row
                          Row(
                            children: [
                              // Age Field
                              Expanded(
                                child: _buildDialogInput(
                                  initialValue: age,
                                  hint: 'Age',
                                  onChanged:
                                      (value) => setStateSB(() => age = value),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 8),

                              // Birth Date Field
                              Expanded(
                                child: _buildDialogInput(
                                  initialValue: birthDate,
                                  hint: 'MM / DD / YYYY',
                                  onChanged:
                                      (value) =>
                                          setStateSB(() => birthDate = value),
                                ),
                              ),
                              const SizedBox(width: 8),

                              // Gender Field
                              Expanded(
                                child: _buildDialogInput(
                                  initialValue: gender,
                                  hint: 'Gender',
                                  onChanged:
                                      (value) =>
                                          setStateSB(() => gender = value),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Describe Skin Concern Label
                          const Text(
                            'Describe your main skin concern',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),

                          // Describe Skin Concern Text Area
                          TextField(
                            controller: concernController,
                            maxLines: 5,
                            minLines: 5,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: 'Describe your condition',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                              contentPadding: const EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                  color: _kPrimaryBlue,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Action Buttons (Cancel and Sent)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _kDarkGrey,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _kPrimaryBlue,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Sent',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Helper Widget for Input Fields
  Widget _buildDialogInput({
    required String hint,
    required String initialValue,
    required Function(String) onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    TextEditingController tempController = TextEditingController(
      text: initialValue,
    );
    tempController.selection = TextSelection.collapsed(
      offset: initialValue.length,
    );

    return TextField(
      onChanged: onChanged,
      controller: tempController,
      textAlign: TextAlign.center,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: _kPrimaryBlue, width: 1.5),
        ),
      ),
    );
  }

  // Helper Widget for Info Rows (Distance, Patients)
  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // --- MAIN WIDGET BUILD ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Find near Clinic',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Blue Header Bar (Wellness Clinic & Rating) ---
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 0,
                bottom: 8,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: _kPrimaryBlue,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Wellness Clinic',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.star, color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text(
                            '4.8',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- 2. Main Content (Image, Address, Links) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Clinic Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          _clinicImageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey.shade300,
                                child: const Icon(
                                  Icons.local_hospital,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Address Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Address:',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Commonwealth Health Center:\nM3WQ+Q73, Commonwealth Ave,\nQuezon City, Metro Manila',
                              style: TextStyle(fontSize: 13),
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              Icons.location_on,
                              '1.2 miles away',
                              _kPrimaryBlue,
                            ),
                            const SizedBox(height: 4),
                            _buildInfoRow(
                              Icons.check_circle,
                              'Accepting new patients',
                              _kPrimaryBlue,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32, thickness: 1, color: Colors.grey),

                  // Doctor Info (Simplified)
                  const Text(
                    'Dr. Sarah Johnson\nCosmetics Dermatology\nAvailable Time: 8:00 AM - 3:00 PM',
                    style: TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons (Message and Schedule)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _showFreeMessageDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _kPrimaryBlue,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
                            'Message',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed:
                              () => _showFreeMessageDialog(
                                context,
                              ), // FIX: Calling the dialog function here
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: _kPrimaryBlue),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
                            'Schedule',
                            style: TextStyle(color: _kPrimaryBlue),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Service Description
                  const Text(
                    'Anti-Aging Treatments',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const Text(
                    '• Smooth away fine lines and wrinkles, restore skin elasticity, and achieve a more youthful, refreshed appearance through advanced techniques like injectables, laser therapy, or collagen-boosting treatments.',
                    style: TextStyle(fontSize: 13, height: 1.5),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Acne Solutions',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const Text(
                    '• Target and clear stubborn breakouts, reduce inflammation.',
                    style: TextStyle(fontSize: 13, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
