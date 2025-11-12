// I changed this from cupertino.dart to material.dart
// because the UI uses Material Design components.
import 'package:ai_skinwise_v2/Pages/LoginSignInPage/Code.dart';
import 'package:ai_skinwise_v2/Pages/LoginSignInPage/Fillupemail.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class verify extends StatefulWidget {
  const verify({super.key});

  @override
  State<verify> createState() => _verifyState();
}

class _verifyState extends State<verify> {
  // A state variable to hold the checkbox's value
  bool _agreedToTerms = false;

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
        // This adds the blue line at the bottom of the app bar
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
            // "Verify Account" Title
            const Text(
              'Verify Account',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),

            // "Example@gmail.com" Subtitle
            // You would replace this with a real email variable
            Text(
              'Example@gmail.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 40),

            // "Send Verification Code" Button
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const Code()
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007AFF), // Blue color
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Send Verification Code',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 24),

            // Terms and Conditions Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Checkbox
                SizedBox(
                  width: 24, // Constrain the size of the checkbox
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

                // Terms Text (using RichText for styling)
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      // Default style for all text
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
                            color: Colors.blue, // Make it look like a link
                            fontWeight: FontWeight.bold,
                          ),
                          // This makes the text tappable
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // TODO: Add action to show terms and conditions
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