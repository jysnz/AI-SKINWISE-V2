// I changed this from cupertino.dart to material.dart
// because the UI uses Material Design components.
import 'package:ai_skinwise_v2/Pages/LoginSignInPage/personalinfo.dart';
import 'package:flutter/material.dart';
// --- ADD THIS IMPORT ---
import 'package:flutter/services.dart';

class Createaccount extends StatefulWidget {
  const Createaccount({super.key});

  @override
  State<Createaccount> createState() => _CreateaccountState();
}

class _CreateaccountState extends State<Createaccount> {
  // A GlobalKey for the Form, used for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers to read the text from the fields
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // A simple boolean to show/hide password
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // This variable will hold the selected country code
  String _selectedCountryCode = '+63';

  // --- State variables for password requirements ---
  bool _isLengthValid = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasNumber = false;
  bool _hasSpecialCharacter = false;

  @override
  void initState() {
    super.initState();
    // Add listener to password controller
    _passwordController.addListener(_validatePassword);
  }

  // --- Function to check password requirements ---
  void _validatePassword() {
    final password = _passwordController.text;
    setState(() {
      _isLengthValid = password.length >= 8;
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasLowercase = password.contains(RegExp(r'[a-z]'));
      _hasNumber = password.contains(RegExp(r'[0-9]'));
      _hasSpecialCharacter =
          password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  // Clean up the controllers when the widget is removed
  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.removeListener(_validatePassword); // Remove listener
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Helper function to build the text field labels
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }

  // Helper function to build the text form fields
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }

  // --- Helper widget for password requirement UI ---
  Widget _buildRequirementRow(String text, bool met) {
    return Row(
      children: [
        Icon(
          met ? Icons.check_circle : Icons.circle_outlined,
          color: met ? Colors.green : Colors.grey,
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: met ? Colors.black87 : Colors.grey[700],
            fontSize: 14,
            fontWeight: met ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  void _onNextPressed() {
    // 1. Check Validation FIRST
    if (_formKey.currentState?.validate() ?? false) {
      String fullPhoneNumber =
          '$_selectedCountryCode${_phoneController.text.trim()}';
      print('Form is valid! Passing data...');

      // 3. Navigate and PASS DATA
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => personalinfo(
              email: _emailController.text.trim(),
              phone: fullPhoneNumber,
              password: _passwordController.text,
            )),
      );
    } else {
      print('Form is invalid.');
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            // autovalidateMode has been removed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                const Text(
                  'Create your account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  'Fill all the information below',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 30),

                const Text(
                  'Account Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const Divider(height: 20),
                const SizedBox(height: 10),

                // Email Field
                _buildLabel('Email'),
                const SizedBox(height: 8),
                _buildTextFormField(
                  controller: _emailController,
                  hintText: 'Your Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                // --- FIX: Reduced spacing ---
                const SizedBox(height: 16), // Was 20

                // Phone Number Field
                _buildLabel('Phone Number'),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Country Code Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 15), // Target padding
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCountryCode,
                          isDense: true, // For alignment
                          items: <String>['+63', '+1', '+44', '+91']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedCountryCode = newValue;
                              });
                            }
                          },
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Phone Number Input
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        // --- FIX: ADDED INPUT FORMATTER ---
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          hintText: 'Phone Number',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          isDense: true, // For alignment
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 12),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                // --- FIX: Reduced spacing ---
                const SizedBox(height: 16), // Was 20

                // Password Field
                _buildLabel('Password'),
                const SizedBox(height: 8),
                _buildTextFormField(
                  controller: _passwordController,
                  hintText: 'Your password',
                  isPassword: _obscurePassword,
                  // --- UPDATED VALIDATOR ---
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (!_isLengthValid ||
                        !_hasUppercase ||
                        !_hasLowercase ||
                        !_hasNumber ||
                        !_hasSpecialCharacter) {
                      return 'Password does not meet all requirements.';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),

                // --- UI FOR PASSWORD REQUIREMENTS ---
                const SizedBox(height: 10), // Was 12
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRequirementRow(
                          'At least 8 characters', _isLengthValid),
                      const SizedBox(height: 6),
                      _buildRequirementRow(
                          'Contains an uppercase letter', _hasUppercase),
                      const SizedBox(height: 6),
                      _buildRequirementRow(
                          'Contains a lowercase letter', _hasLowercase),
                      const SizedBox(height: 6),
                      _buildRequirementRow('Contains a number', _hasNumber),
                      const SizedBox(height: 6),
                      _buildRequirementRow(
                          'Contains a special character', _hasSpecialCharacter),
                    ],
                  ),
                ),
                // --- END OF UI ---

                // --- FIX: Reduced spacing ---
                const SizedBox(height: 16), // Was 20

                // Confirm Password Field
                _buildLabel('Confirm Password'),
                const SizedBox(height: 8),
                _buildTextFormField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm your Password',
                  isPassword: _obscureConfirmPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                // --- FIX: Reduced spacing ---
                const SizedBox(height: 24), // Was 30

                // Next Button
                ElevatedButton(
                  onPressed: _onNextPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007AFF), // Blue color
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                // --- FIX: Reduced spacing ---
                const SizedBox(height: 24), // Was 30
              ],
            ),
          ),
        ),
      ),
    );
  }
}