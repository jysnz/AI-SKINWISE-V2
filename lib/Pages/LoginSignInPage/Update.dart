import 'package:flutter/material.dart';

import 'Login.dart'; // Changed from cupertino.dart

// CLASS NAME FIXED: Renamed to UpperCamelCase 'Update'
class Update extends StatefulWidget {
  const Update({super.key});

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  // Global key to identify the Form
  final _formKey = GlobalKey<FormState>();

  // Controllers to manage the text
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State variable to control the error message visibility
  bool _showPasswordError = false;

  @override
  void dispose() {
    // Clean up the controllers
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    setState(() {
      // Check if the password field is empty
      if (_newPasswordController.text.isEmpty) {
        _showPasswordError = true;
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => const Login()
          ),
        );
      } else {
        _showPasswordError = false;
      }
    });

    // Continue with form validation
    if (_formKey.currentState!.validate()) {
      if (_newPasswordController.text == _confirmPasswordController.text) {
        // TODO: Passwords match, add your update logic
        print('Password updated successfully');
      } else {
        // TODO: Show a snackbar or error for mismatched passwords
        print('Passwords do not match');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 1. AppBar with just the back arrow
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // This ensures the back arrow is black
        iconTheme: IconThemeData(color: Colors.black),
      ),
      // 2. Body with padding
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 3. "Update Password" Title
              const Text(
                'Update Password',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // 4. "Create new password" Subtitle
              Text(
                'Create new password',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),

              // 5. "New Password" Label
              const Text(
                'New Password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // 6. New Password Text Field
              TextFormField(
                controller: _newPasswordController,
                obscureText: true, // Hides password
                decoration: InputDecoration(
                  hintText: 'Your Password',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
                // Simple validation for the form
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    setState(() { _showPasswordError = true; });
                    return null; // Error message is handled externally
                  }
                  return null;
                },
              ),
              // 7. Conditional Error Message
              if (_showPasswordError)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    'Password Required 🔺',
                    style: TextStyle(
                      color: Colors.red[700],
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // 8. "Confirm Password" Label
              const Text(
                'Confirm Password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // 9. Confirm Password Text Field
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true, // Hides password
                decoration: InputDecoration(
                  hintText: 'Your New Password',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // 10. "Confirm" Button (full width)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _validateAndSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1877F2), // Blue color
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}