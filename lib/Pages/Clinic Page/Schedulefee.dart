import 'package:flutter/material.dart';

// --- CONSTANTS FOR STYLING ---
const Color _kPrimaryBlue = Color(0xFF1976D2);
const Color _kPrimaryGreen = Color(0xFF4CAF50); // Green color for the price tag
const Color _kCancelButtonColor = Color(
  0xFF212121,
); // Dark black/grey for Cancel button
const double _kPadding = 16.0;

// -----------------------------------------------------------------
// 1. THE SCHEDULEFEE WIDGET (The main Stateful Widget for the Dialog)
// -----------------------------------------------------------------
class Schedulefee extends StatefulWidget {
  const Schedulefee({super.key});

  // Static method to show the widget as a standard Dialog
  // (Fixes the 'No Material widget found' error at the call site)
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Schedulefee(),
        );
      },
    );
  }

  @override
  State<Schedulefee> createState() => _SchedulefeeState();
}

class _SchedulefeeState extends State<Schedulefee> {
  // --- Form Controllers ---
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _concernController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _sexController.dispose();
    _ageController.dispose();
    _dateController.dispose();
    _concernController.dispose();
    super.dispose();
  }

  // --- Date Picker Logic ---
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: _kPrimaryBlue),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = '${picked.month}/${picked.day}/${picked.year}';
      });
    }
  }

  // --- Form Validation Logic ---
  void _validateAndSchedule() {
    if (_fullNameController.text.isEmpty ||
        _sexController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Appointment scheduled successfully!'),
          backgroundColor: _kPrimaryBlue,
        ),
      );
    }
  }

  // --- Helper Widget: Customized TextField ---
  Widget _buildTextField({
    TextEditingController? controller,
    String? labelText,
    String? hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    VoidCallback? onTap,
    Widget? suffixIcon,
    double height = 40.0,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (labelText != null) ...[
          Text(
            labelText,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
        ],
        SizedBox(
          height: height,
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            readOnly: onTap != null,
            onTap: onTap,
            textAlignVertical: TextAlignVertical.center,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              suffixIcon: suffixIcon,
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.grey[400]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.grey[400]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: _kPrimaryBlue),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- Main Build Method for Dialog Content ---
  @override
  Widget build(BuildContext context) {
    // SingleChildScrollView allows the form to scroll when the keyboard is active
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(_kPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- Schedule Header (Row) ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Schedule',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Pay ₱650.00',
                      style: TextStyle(
                        color: _kPrimaryGreen,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: _kPadding),

                // --- Full Name Field ---
                _buildTextField(
                  controller: _fullNameController,
                  labelText: 'Full Name',
                  height: 40.0,
                ),
                const SizedBox(height: _kPadding),

                // --- Sex, Age, Date Row (3 equal parts) ---
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _sexController,
                        labelText: 'Sex',
                        height: 40.0,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildTextField(
                        controller: _ageController,
                        labelText: 'Age',
                        keyboardType: TextInputType.number,
                        height: 40.0,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildTextField(
                        controller: _dateController,
                        labelText: 'Date',
                        onTap: () => _selectDate(context),
                        hintText: '-- -- --',
                        suffixIcon: const Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey,
                        ),
                        height: 40.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: _kPadding),

                // --- State Your Concern (Multiline) ---
                const Text(
                  'State your concern',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 100, // Fixed height for textarea appearance
                  child: _buildTextField(
                    controller: _concernController,
                    maxLines: 5,
                    height: 100,
                  ),
                ),
                const SizedBox(height: 24),

                // --- Buttons ---
                Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _kCancelButtonColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Continue Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _validateAndSchedule,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _kPrimaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // --- Services Section (The content shown outside the dialog box) ---
          Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(_kPadding),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Anti-Aging Treatments',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '• Smooth away fine lines and wrinkles, restore skin elasticity, and achieve a more youthful, refreshed appearance through advanced techniques like injectables, laser therapy, or collagen-boosting treatments.',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF555555),
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Acne Solutions',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '• Target and clear stubborn breakouts, reduce inflammation, and prevent future acne.',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF555555),
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 20), // Padding below the content
              ],
            ),
          ),
        ],
      ),
    );
  }
}
