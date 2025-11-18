import 'dart:async'; // For Timer
import 'dart:convert'; // For jsonEncode
import 'package:http/http.dart' as http; // For API calls

import 'package:ai_skinwise_v2/Pages/Dashboard_Page/Homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For TextInputFormatter

class Code extends StatefulWidget {
  // We need the email to know who we are verifying
  final String email;
  // NEW: We need the full user data for registration after verification
  final Map<String, dynamic> userData;

  const Code({
    super.key,
    required this.email, // Required parameter
    required this.userData, // NEW: Required user data map
  });

  @override
  State<Code> createState() => _CodeState();
}

class _CodeState extends State<Code> {
  // --- Configuration ---
  final String baseUrl = 'https://ai-skinwise-v2-server.onrender.com';

  // --- State Variables ---
  bool _isVerifying = false; // Loading state for submit
  bool _isResending = false; // Loading state for resend

  // --- Timer Logic ---
  Timer? _timer;
  Duration _duration = const Duration(minutes: 5);

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_duration.inSeconds <= 0) {
        // Crucial Fix: Call setState to update the UI (enable button)
        // AND THEN cancel the timer.
        if (timer.isActive) {
          setState(() {
            _duration = Duration.zero; // Ensure it's exactly zero
            timer.cancel();
          });
        }
      } else {
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
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  // --- OTP Box Logic ---
  final List<TextEditingController> _controllers =
  List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 45,
      height: 45,
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
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
          counterText: "",
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (index < 5) {
              _focusNodes[index + 1].requestFocus();
            } else {
              _focusNodes[index].unfocus();
            }
          } else {
            if (index > 0) {
              _focusNodes[index - 1].requestFocus();
            }
          }
        },
      ),
    );
  }

  // --- API Logic ---

  String _getFullCode() {
    return _controllers.map((controller) => controller.text).join();
  }

  // 1. VERIFY CODE AND REGISTER USER (UPDATED TO PASS PASSWORD)
  Future<void> _submitCode() async {
    final code = _getFullCode();

    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the full 6-digit code.')),
      );
      return;
    }

    setState(() {
      _isVerifying = true;
    });

    try {
      // Create the complete payload including OTP and all registration data.
      final Map<String, dynamic> registrationPayload = {
        // Spread all user data (firstName, lastName, Age, Height, Weight, PhoneNumber, and CRITICALLY, **password**)
        ...widget.userData,

        // Add verification specific fields
        "to": widget.email,
        "code": code,

        // Add createdAt field for Supabase database table
        "createdAt": DateTime.now().toIso8601String(),
      };

      // Assumption: This new endpoint handles:
      // 1. OTP verification.
      // 2. If approved, Supabase AUTH registration (using email and password).
      // 3. Insertion into the userInformation table (using the rest of the data).
      final response = await http.post(
        Uri.parse('$baseUrl/verify-and-register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(registrationPayload),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'approved') {
        // Success! Verification approved and registration presumed complete by backend.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification and Registration Successful!')),
        );

        // Navigate to Homepage
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Homepage()),
        );
      } else {
        // Failure (Wrong code or expired or registration failed)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Invalid code or Registration Failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error connecting to server or processing data: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isVerifying = false;
        });
      }
    }
  }

  // 2. RESEND CODE
  Future<void> _resendCode() async {
    setState(() {
      _isResending = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/send-otp'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "to": widget.email,
          "channel": "email",
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('New code sent!')),
        );
        _resetTimer(); // Reset the 5-minute timer
      } else {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${data['error']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connection failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
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
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter Code',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                'Code sent to ${widget.email}', // Dynamic email
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),

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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  6,
                      (index) => _buildOtpBox(index),
                ),
              ),

              const SizedBox(height: 40),

              // SUBMIT BUTTON
              ElevatedButton(
                onPressed: _isVerifying ? null : _submitCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007AFF),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isVerifying
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(color: Colors.white),
                )
                    : const Text(
                  'Submit Code',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),

              // RESEND BUTTON (FIXED LOGIC)
              Center(
                child: TextButton(
                  // The button is disabled if currently resending OR if the timer is running (> 0).
                  onPressed: (_isResending || _duration.inSeconds > 0)
                      ? null // Disabled
                      : _resendCode, // Enabled
                  child: _isResending
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                    ),
                  )
                      : Text(
                    'Resend Code',
                    style: TextStyle(
                      fontSize: 16,
                      // Color changes based on enabled state
                      color: _duration.inSeconds > 0
                          ? Colors.grey
                          : Colors.green,
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