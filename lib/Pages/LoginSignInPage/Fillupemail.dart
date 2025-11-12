import 'package:ai_skinwise_v2/Pages/LoginSignInPage/Code.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Cntdwncode.dart';

class Fillupemail extends StatefulWidget {
  const Fillupemail({super.key});

  @override
  State<Fillupemail> createState() => _FillupemailState();
}

class _FillupemailState extends State<Fillupemail> {
  // A GlobalKey for the Form, used for validation
  final _formKey = GlobalKey<FormState>();

  // A controller to read the text from the email field
  final _emailController = TextEditingController();

  // Clean up the controller when the widget is removed
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Function to handle the "Send Code" button press
  void _sendCode() {
    // This triggers the validator function in the TextFormField
    if (_formKey.currentState?.validate() ?? false) {
      // If the field is valid, proceed.
      print('Form is valid!');
      print('Sending code to: ${_emailController.text}');

      // TODO: Add your logic to send the email (e.g., Firebase Auth)
      // TODO: Navigate to the "Enter Code" page
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const Cntdwncode(),
        ),
      );
    } else {
      // If the field is invalid, the validator message will show.
      print('Form is invalid.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Set AppBar background to white to match the body
        backgroundColor: Colors.white,
        // Remove shadow
        elevation: 0,
        // Add the back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Standard way to go back to the previous screen
            Navigator.of(context).pop();
          },
        ),
      ),
      // Set background color to white
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

                // "Enter Email" Title
                const Text(
                  'Enter Email',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),

                // "Your email to receive the code" Subtitle
                Text(
                  'Your email to receive the code',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 40),

                // "Email" Label
                const Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),

                // --- Email Text Form Field ---
                TextFormField(
                  controller: _emailController,
                  // Use emailAddress keyboard type for convenience
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Your Email',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  ),
                  // Validator function
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field cannot be empty';
                    }
                    // Simple email validation: checks for '@' and '.'
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Please enter a valid email address';
                    }
                    return null; // Return null if the input is valid
                  },
                ),
                const SizedBox(height: 30),

                // "Send Code" Button
                ElevatedButton(
                  onPressed: _sendCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007AFF), // Blue color
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Send Code',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}