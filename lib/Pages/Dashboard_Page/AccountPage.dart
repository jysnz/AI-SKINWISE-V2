import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Account',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false, // Matched to image's left alignment
        actions: [
          TextButton(
            onPressed: () { /* TODO: Implement Log out logic */ },
            child: const Text(
              'Log out',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "Modify you account info" subtitle
            const Text(
              'Modify you account info',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),

            // Profile picture with edit icon
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const CircleAvatar(
                    radius: 55,
                    backgroundColor: Color(0xFFF0F4F8),
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.blue,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // --- Account Info List ---
            _buildAccountOption(
              title: 'Name',
              value: 'GUEST',
              onTap: () { /* TODO: Navigate to Edit Name Page */ },
            ),
            _buildAccountOption(
              title: 'Phone Number',
              value: 'N/A',
              onTap: () { /* TODO: Navigate to Edit Phone Page */ },
            ),
            _buildAccountOption(
              title: 'Email',
              value: 'N/A',
              onTap: () { /* TODO: Navigate to Edit Email Page */ },
            ),
            _buildAccountOption(
              title: 'Age',
              value: 'N/A',
              onTap: () { /* TODO: Navigate to Edit Age Page */ },
            ),
            _buildAccountOption(
              title: 'Height',
              value: 'N/A',
              onTap: () { /* TODO: Navigate to Edit Height Page */ },
            ),
            _buildAccountOption(
              title: 'Weight',
              value: 'N/A',
              onTap: () { /* TODO: Navigate to Edit Weight Page */ },
            ),

            // --- ADDED LINE ---
            // This is the blue line from the bottom of the screenshot
            const Padding(
              padding: EdgeInsets.only(top: 8.0), // Add some space
              child: Divider(
                color: Colors.blue, // Color from the image
                thickness: 0.5,     // Thin line
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper widget to create the repeatable list items
  Widget _buildAccountOption({
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey,
        size: 16,
      ),
      onTap: onTap,
    );
  }
}