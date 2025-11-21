import 'dart:convert'; // Needed for jsonEncode
import 'dart:io';
import 'package:http/http.dart' as http; // Needed for API calls

import 'package:ai_skinwise_v2/Pages/LoginSignInPage/Code.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class verify extends StatefulWidget {
  // --- ACCEPT ALL 9 PIECES OF DATA ---
  final String email;
  final String phone;
  final String password;
  final String firstName;
  final String lastName;
  final String age;
  final String height;
  final String weight;
  final File? profileImage;
  final String heightUnit;
  final String weightUnit;

  const verify({
    super.key,
    required this.email,
    required this.phone,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.height,
    required this.weight,
    this.profileImage,
    required this.heightUnit,
    required this.weightUnit
  });

  @override
  State<verify> createState() => _verifyState();
}

class _verifyState extends State<verify> {
  bool _agreedToTerms = false;
  bool _isLoading = false; // To show a loading spinner

  // --- API FUNCTION ---
  Future<void> _sendVerificationCode() async {

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the Terms and Conditions.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // 2. Your Render Backend URL
    const String backendUrl = 'https://ai-skinwise-v2-server.onrender.com/send-otp';

    try {
      // 3. Call the API
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "to": widget.email,   // Passing the email from the widget
          "channel": "email"    // Telling backend to use email channel
        }),
      );

      // 4. Check Response
      if (response.statusCode == 200) {
        // Success! Code sent. Now prepare the full user data for the next screen.
        if (!mounted) return; // Check if widget is still on screen

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification code sent!')),
        );

        // --- PREPARE USER DATA FOR REGISTRATION ---
        final Map<String, dynamic> userData = {
          // Fields required by the Supabase table (userInformation)
          'firstName': widget.firstName,
          'lastName': widget.lastName,
          'Age': widget.age,
          'Height': '${widget.height} ${widget.heightUnit}', // Combine height and unit
          'Weight': '${widget.weight} ${widget.weightUnit}', // Combine weight and unit
          'PhoneNumber': widget.phone,
          // Other essential registration data (not saved in the Supabase table but needed for user management)
          'password': widget.password,
          // Profile image is typically handled separately (e.g., uploaded to storage bucket)
          // For now, we omit File? profileImage from the JSON/Map being sent to Code screen,
          // as the Code screen's API call only needs text data for the Supabase insertion.
        };
        // ------------------------------------------

        // Navigate to the Code page, passing both email and the full userData map
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Code(
              email: widget.email,
              userData: userData, // PASS THE FULL DATA HERE
            ),
          ),
        );
      } else {
        // Server returned an error (e.g., 400 or 500)
        if (!mounted) return;
        final errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${errorData['error'] ?? 'Unknown error'}')),
        );
      }
    } catch (e) {
      // Network error (e.g., no internet)
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connection failed: $e')),
      );
    } finally {
      // Stop loading spinner
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.blue.withOpacity(0.5),
            height: 1.0,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Verify Account',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),

            // Display the actual email passed to the widget
            Text(
              widget.email,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 40),

            // "Send Verification Code" Button
            ElevatedButton(
              onPressed: _isLoading ? null : _sendVerificationCode, // Disable button if loading
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007AFF),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.0,
                ),
              )
                  : const Text(
                'Send Verification Code',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 24),

            // Terms and Conditions Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _agreedToTerms,
                    onChanged: (bool? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _agreedToTerms = newValue;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                      children: [
                        const TextSpan(
                          text:
                          'By using AI-SKINWISE, you agree to our Terms and Conditions, your privacy and safety are our top priorities. ',
                        ),
                        TextSpan(
                          text: 'Read the full terms for details.',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('Terms tapped!');
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}