// I changed this from cupertino.dart to material.dart
// because the UI uses Material Design components.
import 'package:ai_skinwise_v2/Pages/LoginSignInPage/CreateAccount.dart';
import 'package:ai_skinwise_v2/Pages/LoginSignInPage/Fillupemail.dart';
import 'package:flutter/material.dart';

// Added this import for the Google Sign-In logic
import 'package:google_sign_in/google_sign_in.dart';

import '../Dashboard_Page/Homepage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // This function will trigger the Google pop-up
  Future<void> _handleSignIn() async {
    // This is the main object for handling Google Sign-In
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      // This will open the account chooser pop-up (Screen 2 from your image)
      final GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account != null) {
        // User is successfully signed in
        print('Signed in as: ${account.displayName}');
        print('User email: ${account.email}');

        // TODO:
        // Now you would navigate to your app's home screen
        // For example:
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
      } else {
        // User cancelled the sign-in
        print('User cancelled the sign-in.');
      }
    } catch (error) {
      // Handle any errors that might occur
      print('Sign in failed: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Replaced const Placeholder() with the Scaffold for your UI
    return Scaffold(
      // The back arrow
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // Using `leading` to place the icon on the left
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Handle back button press
            // e.g., Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      // Use SingleChildScrollView to prevent overflow when the keyboard appears
      body: SingleChildScrollView(
        child: Padding(
          // Symmetric horizontal padding for the whole form
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            // Aligns all children to the start (left)
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // "Welcome Back!" Text
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // "Sign to your account" Subtitle
              Text(
                'Sign to your account',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),

              // Email Label
              const Text(
                'Email',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // Email Text Field
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Your Email',
                  filled: true,
                  fillColor: Colors.grey[100],
                  // Creates the rounded border with no outline
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
              ),
              const SizedBox(height: 20),

              // Password Label
              const Text(
                'Password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // Password Text Field
              TextFormField(
                obscureText: true, // Hides the password
                decoration: InputDecoration(
                  hintText: 'Your Password',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
              ),
              const SizedBox(height: 12),

              // Forgot Password Button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const Fillupemail()
                      ),
                    );
                  },
                  child: const Text('Forgot Password?'),
                ),
              ),
              const SizedBox(height: 20),

              // Log in Button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const Homepage()
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007AFF), // Blue color
                  minimumSize: const Size(double.infinity, 50), // Full width
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
              const SizedBox(height: 30),

              // "Don't have an account?" Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account yet?"),
                  TextButton(
                    onPressed: () {
                      // YOU NEED TO DO THIS:
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const Createaccount()
                        ),
                      );
                    },
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // "Or with" Divider
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('Or with'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 30),

              // Sign in with Google Button
              ElevatedButton(
                onPressed: _handleSignIn, // Triggers Google Sign-In
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200], // Light grey background
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // A simple Google 'G' logo placeholder.
                    // You should replace this with the actual Google logo asset
                    Image.network(
                      'http://pngimg.com/uploads/google/google_PNG19635.png',
                      height: 24.0,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Sign in with Google',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Login as Guest Button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const Homepage()
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  const Color(0xFF32A8FF), // Lighter blue color
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Login as Guest',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 40), // Extra space at the bottom
            ],
          ),
        ),
      ),
    );
  }
}