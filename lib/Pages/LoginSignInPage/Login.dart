// I changed this from cupertino.dart to material.dart
// because the UI uses Material Design components.
import 'package:ai_skinwise_v2/Pages/LoginSignInPage/CreateAccount.dart';
import 'package:ai_skinwise_v2/Pages/LoginSignInPage/Fillupemail.dart';
import 'package:flutter/material.dart';
import 'package:ai_skinwise_v2/Supabase/supabase_config.dart';


// Added this import for the Google Sign-In logic
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../Dashboard_Page/Homepage.dart';

class Login extends StatefulWidget {

  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController emailController = TextEditingController ();
  TextEditingController passwordController = TextEditingController ();
  bool _isLoading = false;
  bool _obscurePassword = true;

  // This function will trigger the Google pop-up
  Future<void> loginWithEmail() async {
    final supabase = Supabase.instance.client;
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both email and password.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    print("Attempting Auth login for: $email");

    try {
      final AuthResponse response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      print("LOGIN SUCCESS! User ID: ${response.user?.id}");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login Successful!")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Homepage()),
        );
      }
    } on AuthException catch (e) {
      print("LOGIN FAILED: ${e.message}");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("UNEXPECTED ERROR: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("An unexpected error occurred.")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Your Email',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
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
                controller: passwordController,
                obscureText: _obscurePassword, // 2. Use state variable here
                decoration: InputDecoration(
                  hintText: 'Your Password',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  // 3. Add the Eye Icon button here
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Choose icon based on state
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      // Toggle the state
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
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
                  loginWithEmail();
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
                onPressed: (){}, // Triggers Google Sign-In
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