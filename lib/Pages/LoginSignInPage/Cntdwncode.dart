// I changed this from cupertino.dart to material.dart
// because the UI uses Material Design components.
import 'dart:async'; // Import this for the Timer
import 'package:ai_skinwise_v2/Pages/LoginSignInPage/Update.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For TextInputFormatter

class Cntdwncode extends StatefulWidget {
  const Cntdwncode({super.key});

  @override
  State<Cntdwncode> createState() => _CntdwncodeState();
}

class _CntdwncodeState extends State<Cntdwncode> {
  // --- Timer Logic ---
  Timer? _timer;
  Duration _duration = const Duration(minutes: 5);

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    // Cancel any existing timer
    _timer?.cancel();

    // Start a new timer that ticks every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_duration.inSeconds == 0) {
        // If timer reaches 0, stop it
        timer.cancel();
      } else {
        // Otherwise, decrease duration by 1 second
        setState(() {
          _duration = _duration - const Duration(seconds: 1);
        });
      }
    });
  }

  void _resetTimer() {
    setState(() {
      _duration = const Duration(minutes: 5);
    });
    _startTimer();
  }

  @override
  void dispose() {
    // Important: Cancel the timer when the widget is removed
    _timer?.cancel();
    super.dispose();
  }

  // Helper function to format duration as "mm:ss"
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
  // --- End of Timer Logic ---

  // --- OTP Box Logic ---
  // We need a controller and focus node for each of the 6 boxes
  final List<TextEditingController> _controllers =
  List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  // Helper function to build a single OTP box
  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 45, // Width of each box
      height: 45, // Height of each box
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        // Only allow a single digit
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          counterText: "", // Hides the small character counter
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            // If a digit is entered, move to the next box
            if (index < 5) {
              _focusNodes[index + 1].requestFocus();
            } else {
              // If it's the last box, unfocus to hide keyboard
              _focusNodes[index].unfocus();
            }
          } else {
            // If a digit is deleted, move to the previous box
            if (index > 0) {
              _focusNodes[index - 1].requestFocus();
            }
          }
        },
      ),
    );
  }
  // --- End of OTP Box Logic ---

  // Function to get the full 6-digit code
  String _getFullCode() {
    return _controllers.map((controller) => controller.text).join();
  }

  void _submitCode() {
    final code = _getFullCode();
    if (code.length == 6) {
      print('Submitting code: $code');
      // TODO: Add your code verification logic here
    } else {
      // TODO: Show an error if the code is not complete
      print('Code is incomplete.');
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "Enter Code" Title
              const Text(
                'Enter Code',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // "Code sent to..." Subtitle
              Text(
                'Code sent to Example@gmail.com', // You would pass this in
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),

              // "You'll be able to..." Text
              Center(
                child: Text(
                  "You'll be able to use the code within 5 minutes",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Timer Display
              Center(
                child: Text(
                  _formatDuration(_duration),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // --- OTP Boxes ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  6,
                      (index) => _buildOtpBox(index),
                ),
              ),
              // --- End of OTP Boxes ---

              const SizedBox(height: 40),

              // "Submit Code" Button
              ElevatedButton(
                onPressed: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const Update()
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
                  'Submit Code',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),

              // "Resend Code" Button
              Center(
                child: TextButton(
                  onPressed: () {
                    // Only allow resend if timer is up, or with a delay
                    if (_duration.inSeconds == 0) {
                      print('Resending code...');
                      _resetTimer();
                      // TODO: Add logic to resend the code
                    }
                  },
                  child: Text(
                    'Resend Code',
                    style: TextStyle(
                      fontSize: 16,
                      color: _duration.inSeconds == 0
                          ? Colors.green // Active color
                          : Colors.grey, // Disabled color
                      fontWeight: FontWeight.bold,
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