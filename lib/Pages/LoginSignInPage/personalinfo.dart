// I changed this from cupertino.dart to material.dart
// because the UI uses Material Design components.
import 'package:ai_skinwise_v2/Pages/LoginSignInPage/verify.dart';
import 'package:flutter/material.dart';
// --- NEW IMPORTS ---
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Required for handling the File

class personalinfo extends StatefulWidget {
  const personalinfo({super.key});

  @override
  State<personalinfo> createState() => _personalinfoState();
}

class _personalinfoState extends State<personalinfo> {
  // A GlobalKey for the Form, used for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers to read the text from the fields
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  // --- NEW STATE VARIABLE ---
  // This will hold the path to the selected image file
  File? _profileImage;

  // Clean up the controllers when the widget is removed
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  // --- NEW FUNCTION ---
  // This function handles picking an image from the gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Open the gallery to pick an image
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

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

  // Helper function to build the text form fields
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
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

  // Function to handle the "Log in" button press
  void _submitForm() {
    // This triggers the validator functions in each TextFormField
    if (_formKey.currentState?.validate() ?? false) {
      // If all fields are valid, proceed.
      print('Form is valid!');
      print('First Name: ${_firstNameController.text}');
      print('Last Name: ${_lastNameController.text}');
      print('Age: ${_ageController.text}');
      print('Height: ${_heightController.text}');
      print('Weight: ${_weightController.text}');
      // --- NEW ---
      // You can now also access the selected image path
      if (_profileImage != null) {
        print('Profile Image Path: ${_profileImage!.path}');
        // TODO: Add logic to upload this image file
      } else {
        print('No profile image selected.');
      }

      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const verify()),
      );
    } else {
      // If any field is invalid, the validator messages will show.
      print('Form is invalid.');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Replaced const Placeholder() with the Scaffold for your UI
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

                // --- UPDATED Profile Picture Icon ---
                Center(
                  child: Stack(
                    clipBehavior: Clip.none, // Allow edit icon to go outside
                    children: [
                      // This CircleAvatar now displays the image
                      CircleAvatar(
                        radius: 60,
                        // Use FileImage if _profileImage is not null
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        // Show grey background only if no image is selected
                        backgroundColor: _profileImage == null
                            ? Colors.grey[200]
                            : Colors.transparent,
                        // Show Icon only if no image is selected
                        child: _profileImage == null
                            ? Icon(
                          Icons.person,
                          size: 70,
                          color: Colors.grey[600],
                        )
                            : null, // No child when image is displayed
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
                              // --- UPDATED ---
                              // Call our new function on press
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

                // Age Field
                _buildLabel('Age'),
                const SizedBox(height: 8),
                _buildTextFormField(
                  controller: _ageController,
                  hintText: 'Your age',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),

                // Height Field
                _buildLabel('Height'),
                const SizedBox(height: 8),
                _buildTextFormField(
                  controller: _heightController,
                  hintText: 'Your height',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),

                // Weight Field
                _buildLabel('Weight'),
                const SizedBox(height: 8),
                _buildTextFormField(
                  controller: _weightController,
                  hintText: 'Your weight',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 40),

                // "Log in" Button (as per screenshot)
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
                    'Log in',
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
