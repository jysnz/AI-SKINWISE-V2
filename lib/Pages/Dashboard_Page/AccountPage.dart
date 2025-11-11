import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // This is still needed for your "Back" button
        leadingWidth: 100,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Row(
            children: const [
              SizedBox(width: 15),
              Icon(Icons.arrow_back, color: Colors.black, size: 24.0),
              SizedBox(width: 10),
              Text(
                'Back',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // MODIFIED THIS SECTION
        actions: [
          Padding(
            // This padding matches the body's horizontal padding (20.0)
            padding: const EdgeInsets.only(right: 10.0),
            child: TextButton.icon(
              onPressed: () { /* TODO: Log out */ },
              icon: const Icon(Icons.logout, color: Colors.red, size: 24.0),
              label: const Text(
                'Log out',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),

      // The body starts here (no changes)
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(height: 1, thickness: 0.5),
            const Divider(height: 1, thickness: 0.5),
            const SizedBox(height: 15),
            const Text(
              'Account',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                'Modify your account info', // Typo fixed
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 24),
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
                      color: Color(0xFF005DA1),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Color(0xFF005DA1),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.edit, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Divider(height: 1, thickness: 0.5),
            _buildAccountOption(title: 'Name', value: 'GUEST', onTap: () {}),
            const Divider(height: 1, thickness: 0.5),
            _buildAccountOption(title: 'Phone Number', value: 'N/A', onTap: () {}),
            const Divider(height: 1, thickness: 0.5),
            _buildAccountOption(title: 'Email', value: 'N/A', onTap: () {}),
            const Divider(height: 1, thickness: 0.5),
            _buildAccountOption(title: 'Age', value: 'N/A', onTap: () {}),
            const Divider(height: 1, thickness: 0.5),
            _buildAccountOption(title: 'Height', value: 'N/A', onTap: () {}),
            const Divider(height: 1, thickness: 0.5),
            _buildAccountOption(title: 'Weight', value: 'N/A', onTap: () {}),
            const Divider(height: 1, thickness: 0.5),
            const SizedBox(height: 10),
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
          color: Color(0xFF005DA1),
          fontWeight: FontWeight.w700,
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