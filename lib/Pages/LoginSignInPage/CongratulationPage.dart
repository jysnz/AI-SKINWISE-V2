import 'package:flutter/material.dart';
import 'package:ai_skinwise_v2/Pages/Dashboard_Page/Homepage.dart'; // Import your Homepage

class CongratulationPage extends StatefulWidget {
  final String email;

  // 2. Add it to the constructor
  const CongratulationPage({
    super.key,
    required this.email,
  });

  @override
  State<CongratulationPage> createState() => _CongratulationPageState();
}

class _CongratulationPageState extends State<CongratulationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // Animated Checkmark Icon
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(20),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 100,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              // Title Text
              const Text(
                "Account Created!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 16),

              // Subtitle Text
              Text(
                "Congratulations! Your account has been successfully verified and registered. You are now ready to explore SkinWise.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),

              const Spacer(),

              // "Get Started" / "Continue" Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to Homepage and remove all previous routes
                    // (So the user can't go back to the OTP screen)
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Homepage(email: widget.email)),
                          (Route<dynamic> route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007AFF), // Your App Blue Color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Let's Get Started",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}