// I changed this from cupertino.dart to material.dart
// because the UI uses Material Design components.
import 'dart:io';

import 'package:ai_skinwise_v2/Pages/LoginSignInPage/verify.dart';
import 'package:flutter/material.dart';
// --- NEW IMPORTS ---
import 'package:image_picker/image_picker.dart';
// --- ADD THIS IMPORT ---
import 'package:flutter/services.dart';

class personalinfo extends StatefulWidget {
  // 1. Add these final variables to hold the data
  final String email;
  final String phone;
  final String password;

  // 2. Update the constructor to require these variables
  const personalinfo({
    super.key,
    required this.email,
    required this.phone,
    required this.password,
  });

  @override
  State<personalinfo> createState() => _personalinfoState();
}

class _personalinfoState extends State<personalinfo> {
  // A GlobalKey for the Form, used for validation
  final _formKey = GlobalKey<FormState>();

  // --- NEW: Add a variable to control auto-validation ---
  bool _autoValidate = false;

  // Controllers to read the text from the fields
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();

  // --- NEW: Separate controllers for cm vs. ft/in ---
  final _heightCmController = TextEditingController();
  final _heightFtController = TextEditingController();
  final _heightInController = TextEditingController();

  // This will hold the path to the selected image file
  File? _profileImage;

  // --- NEW: State variables for units (now lowercase) ---
  String _selectedHeightUnit = 'cm';
  String _selectedWeightUnit = 'kg';

  // Clean up the controllers when the widget is removed
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    // --- NEW: Dispose all height controllers ---
    _heightCmController.dispose();
    _heightFtController.dispose();
    _heightInController.dispose();
    super.dispose();
  }

  // This function handles picking an image from the gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Open the gallery to pick an image
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // If an image is selected, update the state to display it
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    } else {
      // User canceled the picker
      print('No image selected.');
    }
  }

  // Helper function to build the text field labels
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }

  // Helper function for simple text form fields
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters, // Apply formatters
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
      validator: validator ??
              (value) {
            if (value == null || value.isEmpty) {
              return 'This field cannot be empty';
            }
            return null;
          },
    );
  }

  // --- UPDATED: Function to handle the "Next" button press ---
  void _submitForm() {
    // --- NEW: First, turn on auto-validation for future edits ---
    setState(() {
      _autoValidate = true;
    });

    // This triggers the validator functions in each TextFormField
    if (_formKey.currentState?.validate() ?? false) {
      // If all fields are valid, proceed.
      print('Form is valid! Passing all data to verify page...');

      // --- NEW: Consolidate height based on selected unit ---
      String heightValue;
      if (_selectedHeightUnit == 'cm') {
        heightValue = _heightCmController.text.trim();
      } else {
        heightValue =
        "${_heightFtController.text.trim()}'${_heightInController.text.trim()}";
      }

      // --- FIXED: Navigate and PASS ALL DATA (including units) ---
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => verify(
            // Pass data from Createaccount page
            email: widget.email,
            phone: widget.phone,
            password: widget.password,

            // Pass data from this page
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            age: _ageController.text.trim(),
            height: heightValue, // Pass the consolidated value
            heightUnit: _selectedHeightUnit, // NEW
            weight: _weightController.text.trim(),
            weightUnit: _selectedWeightUnit, // NEW
            profileImage: _profileImage, // Pass the File object
          ),
        ),
      );
    } else {
      // If any field is invalid, the validator messages will show.
      print('Form is invalid.');
    }
  }

  // Helper widget to build unit dropdowns
  Widget _buildUnitDropdown(
      String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }

  // --- NEW: Helper for the small Feet/Inches fields ---
  Widget _buildUnitInput(
      TextEditingController controller, String hint, String? Function(String?) validator) {
    return Expanded(
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(2), // 'Ft' is 1, 'In' can be 2
        ],
        validator: validator,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          isDense: true,
          contentPadding:
          const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    // =======================================================================
    // --- DYNAMIC LOGIC ---
    // =======================================================================
    bool isCm = _selectedHeightUnit == 'cm';
    bool isKg = _selectedWeightUnit == 'kg';

    // --- NEW: Build the correct height widget based on unit ---
    Widget heightInputWidget;
    if (isCm) {
      // --- 1. CM WIDGET ---
      heightInputWidget = Expanded(
        child: TextFormField(
          controller: _heightCmController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(3),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) return 'Enter cm';
            final h = int.tryParse(value);
            if (h == null) return 'Invalid';
            if (h < 50 || h > 250) return '50-250 cm';
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Your height (cm)',
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            isDense: true,
            contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
          ),
        ),
      );
    } else {
      // --- 2. FEET/INCHES WIDGET ---
      heightInputWidget = Expanded(
        child: Row(
          children: [
            // --- Feet Field ---
            _buildUnitInput(_heightFtController, 'Ft', (value) {
              if (value == null || value.isEmpty) return 'Enter Ft';
              final ft = int.tryParse(value);
              if (ft == null) return 'Invalid';
              if (ft < 1 || ft > 9) return '1-9';
              return null;
            }),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("'", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            // --- Inches Field ---
            _buildUnitInput(_heightInController, 'In', (value) {
              if (value == null || value.isEmpty) return 'Enter In';
              final inc = int.tryParse(value);
              if (inc == null) return 'Invalid';
              if (inc < 0 || inc > 11) return '0-11';
              return null;
            }),
          ],
        ),
      );
    }

    // Weight Logic (unchanged from before, but good to have)
    String weightHintText = isKg ? 'Your weight (kg)' : 'Your weight (lbs)';
    String? Function(String?) weightValidator = (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter weight';
      }
      final weight = int.tryParse(value);
      if (weight == null) {
        return 'Invalid number';
      }
      if (isKg) {
        if (weight < 20 || weight > 250) return '20-250 kg';
      } else {
        if (weight < 40 || weight > 550) return '40-550 lbs';
      }
      return null; // Valid
    };
    // =======================================================================
    // --- END OF DYNAMIC LOGIC ---
    // =======================================================================

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          // We use a Form widget to get validation features
          child: Form(
            key: _formKey,
            // --- UPDATED: Use dynamic auto-validation ---
            autovalidateMode: _autoValidate
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // "Create your account" Title
                const Text(
                  'Create your account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),

                // "Fill all the information..." Subtitle
                Text(
                  'Fill all the information below',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 30),

                // "Personal Information" Section Title
                const Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const Divider(height: 20),
                const SizedBox(height: 30),

                // --- Profile Picture Icon ---
                Center(
                  child: Stack(
                    clipBehavior: Clip.none, // Allow edit icon to go outside
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        backgroundColor: _profileImage == null
                            ? Colors.grey[200]
                            : Colors.transparent,
                        child: _profileImage == null
                            ? Icon(
                          Icons.person,
                          size: 70,
                          color: Colors.grey[600],
                        )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: -5,
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white, // White border
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: const Color(0xFF007AFF), // Blue
                            child: IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: _pickImage,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // First Name Field
                _buildLabel('First Name'),
                const SizedBox(height: 8),
                _buildTextFormField(
                  controller: _firstNameController,
                  hintText: 'Your first name',
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 20),

                // Last Name Field
                _buildLabel('Last Name'),
                const SizedBox(height: 8),
                _buildTextFormField(
                  controller: _lastNameController,
                  hintText: 'Your last name',
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 20),

                // --- UPDATED Age Field ---
                _buildLabel('Age'),
                const SizedBox(height: 8),
                _buildTextFormField(
                  controller: _ageController,
                  hintText: 'Your age',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    final age = int.tryParse(value);
                    if (age == null) {
                      return 'Please enter a valid number';
                    }
                    if (age < 1) {
                      return 'Age must be at least 1';
                    }
                    if (age > 130) {
                      return 'Age cannot be over 130';
                    }
                    return null; // Valid
                  },
                ),
                const SizedBox(height: 20),

                // --- UPDATED Height Field (Now uses dynamic logic) ---
                _buildLabel('Height'),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align to top
                  children: [
                    // --- This is now the dynamic widget (cm or ft/in) ---
                    heightInputWidget,
                    const SizedBox(width: 12),
                    // --- Height Dropdown ---
                    _buildUnitDropdown(
                      _selectedHeightUnit,
                      ['cm', 'in'], // --- FIX: Lowercase units ---
                          (String? newValue) {
                        // --- UPDATED: Clear text on change ---
                        if (newValue != null &&
                            newValue != _selectedHeightUnit) {
                          setState(() {
                            _selectedHeightUnit = newValue;
                            // Clear all possible height fields
                            _heightCmController.clear();
                            _heightFtController.clear();
                            _heightInController.clear();
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // --- UPDATED Weight Field (Now uses dynamic logic) ---
                _buildLabel('Weight'),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align to top
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        validator: weightValidator,
                        decoration: InputDecoration(
                          hintText: weightHintText,
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          isDense: true, // For alignment
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _buildUnitDropdown(
                      _selectedWeightUnit,
                      ['kg', 'lbs'], // --- FIX: Lowercase units ---
                          (String? newValue) {
                        // --- UPDATED: Clear text on change ---
                        if (newValue != null &&
                            newValue != _selectedWeightUnit) {
                          setState(() {
                            _selectedWeightUnit = newValue;
                            _weightController.clear(); // Clear text
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // --- UPDATED: "Next" Button ---
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007AFF), // Blue color
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Next', // --- Changed from "Log in" ---
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 40), // Extra space at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}