import 'package:flutter/material.dart'; // Changed from cupertino.dart
import 'package:pinput/pinput.dart'; // Required for the code field

// CLASS NAME FIXED: Renamed to UpperCamelCase 'Cntdwncode'
class Cntdwncode extends StatefulWidget {
  const Cntdwncode({super.key});

  @override
  State<Cntdwncode> createState() => _CntdwncodeState();
}

class _CntdwncodeState extends State<Cntdwncode> {
  // Controller to manage the text in the code field
  final _pinController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Theme for the pinput field (the dashes)
    final defaultPinTheme = PinTheme(
      width: 45,
      height: 50,
      textStyle: TextStyle(
        fontSize: 22,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 2, color: Colors.grey.shade400)),
      ),
    );

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 3. "Enter Code" Title
            const Text(
              'Enter Code',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),

            // 4. "Code sent to..." Subtitle
            Text(
              'Code sent to Example@gmail.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),

            // 5. "You'll be able..." subtitle
            const Text(
              "You'll be able to use the code within 5 minutes",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),

            // 6. Timer (static text)
            Center(
              child: Text(
                '5:00', // Static text, no timer logic
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 7. Pinput (OTP) field (centered)
            Center(
              child: Pinput(
                controller: _pinController,
                length: 6, // 6 digits
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyDecorationWith(
                  border: Border(bottom: BorderSide(width: 2, color: Color(0xFF1877F2))),
                ),
                onCompleted: (pin) {
                  // UI only, no logic
                },
              ),
            ),
            const SizedBox(height: 32),

            // 8. "Submit Code" Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // UI only, no logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1877F2),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Submit Code',
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
    );
  }
}