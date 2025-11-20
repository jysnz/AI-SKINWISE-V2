import 'dart:io'; // For File handling
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../LoginSignInPage/Login.dart'; // Required for image selection
// Replace with your actual Login Page import path

class AccountPage extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const AccountPage({Key? key, this.userData}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late String _firstName;
  late String _lastName;
  late String _phone;
  late String _email;
  late String _age;
  late String _height;
  late String _weight;
  String? _profileImageUrl; // To hold the cloud URL
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    final data = widget.userData;
    _firstName = data?['firstName'] ?? "Guest";
    _lastName = data?['LastName'] ?? "";
    _phone = data?['PhoneNumber'] ?? "N/A";
    _email = data?['email'] ?? "N/A";
    _age = data?['Age']?.toString() ?? "N/A";
    _height = data?['Height']?.toString() ?? "N/A";
    _weight = data?['Weight']?.toString() ?? "N/A";
    // Assuming your DB column is named 'profile_image'
    _profileImageUrl = data?['profile_image'];
  }

  // --- IMAGE PICKER & UPLOAD LOGIC ---

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        // Show confirmation dialog with the selected image
        _showImagePreviewDialog(File(image.path));
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  void _showImagePreviewDialog(File imageFile) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Update Profile Photo",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF005DA1)
                ),
              ),
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 60,
                backgroundImage: FileImage(imageFile),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      _pickImage(); // Re-open picker
                    },
                    child: const Text("Select Again", style: TextStyle(color: Colors.grey)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005DA1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      _uploadImageToSupabase(imageFile); // Start Upload
                    },
                    child: const Text("Update Photo", style: TextStyle(color: Colors.white)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _uploadImageToSupabase(File imageFile) async {
    setState(() => _isLoading = true);
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw "User not authenticated";

      // 1. Delete Existing Image if it exists (and is not a placeholder)
      if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) {
        await _deleteOldImage(_profileImageUrl!);
      }

      // 2. Upload New Image
      // Path format: userId/timestamp.jpg to ensure uniqueness
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String path = '$userId/$fileName';

      await Supabase.instance.client.storage
          .from('Profile_images')
          .upload(path, imageFile);

      // 3. Get Public URL
      final String publicUrl = Supabase.instance.client.storage
          .from('Profile_images')
          .getPublicUrl(path);

      // 4. Update Database
      await Supabase.instance.client
          .from('UserInformation')
          .update({'profile_image': publicUrl})
          .eq('email', _email);

      // 5. Update Local State
      setState(() {
        _profileImageUrl = publicUrl;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile photo updated!"), backgroundColor: Colors.green),
        );
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload failed: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteOldImage(String url) async {
    try {
      // Extract path from URL.
      final Uri uri = Uri.parse(url);
      // Check if the URL actually belongs to Supabase Storage before trying to delete
      if (url.contains('Profile_images')) {
        final String path = uri.pathSegments.sublist(uri.pathSegments.indexOf('Profile_images') + 1).join('/');

        await Supabase.instance.client.storage
            .from('Profile_images')
            .remove([path]);
      }
    } catch (e) {
      print("Error deleting old image: $e");
      // Continue execution even if delete fails
    }
  }

  // --- DATABASE UPDATE LOGIC ---
  Future<void> _updateDatabase(String column, String value) async {
    if (_email == "N/A") return;
    setState(() => _isLoading = true);

    try {
      dynamic finalValue = value;
      if (['Age', 'Height', 'Weight'].contains(column)) {
        finalValue = int.tryParse(value) ?? 0;
      }

      await Supabase.instance.client
          .from('UserInformation')
          .update({column: finalValue})
          .eq('email', _email);

      String readableField = _getReadableName(column);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$readableField updated successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating ${_getReadableName(column)}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- LOGOUT LOGIC WITH DIALOG ---
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Log Out", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Are you sure you want to log out of your account?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(context); // Close dialog
              _handleLogout(); // Perform logout
            },
            child: const Text("Log Out", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout() async {
    setState(() => _isLoading = true);
    try {
      if (_email != "N/A") {
        await Supabase.instance.client
            .from('UserInformation')
            .update({'is_online': false})
            .eq('email', _email);
      }
      await Supabase.instance.client.auth.signOut();

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Login()),
            (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
      setState(() => _isLoading = false);
    }
  }

  // --- EDIT TEXT DIALOG ---
  void _showEditDialog(String title, String currentValue, String dbColumn) {
    TextEditingController controller = TextEditingController(text: currentValue == "N/A" ? "" : currentValue);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "Edit $title",
                  style: const TextStyle(
                      color: Color(0xFF005DA1),
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  )
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                autofocus: true,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: "Enter new $title",
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF005DA1), width: 2),
                  ),
                ),
                keyboardType: ['Age', 'Height', 'Weight', 'Phone Number'].contains(title)
                    ? TextInputType.number
                    : TextInputType.text,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
                    child: const Text("Cancel", style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005DA1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      setState(() {
                        switch (dbColumn) {
                          case 'firstName': _firstName = controller.text; break;
                          case 'LastName': _lastName = controller.text; break;
                          case 'PhoneNumber': _phone = controller.text; break;
                          case 'Age': _age = controller.text; break;
                          case 'Height': _height = controller.text; break;
                          case 'Weight': _weight = controller.text; break;
                        }
                      });
                      _updateDatabase(dbColumn, controller.text);
                      Navigator.pop(context);
                    },
                    child: const Text("Save", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReadOnlyDialog(String title, String value) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Color(0xFF005DA1), fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SelectableText(value, style: const TextStyle(fontSize: 16, color: Colors.black87)),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close", style: TextStyle(fontSize: 16, color: Color(0xFF005DA1))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getReadableName(String dbColumn) {
    switch (dbColumn) {
      case 'firstName': return 'First Name';
      case 'LastName': return 'Last Name';
      case 'PhoneNumber': return 'Phone Number';
      case 'Age': return 'Age';
      case 'Height': return 'Height';
      case 'Weight': return 'Weight';
      default: return dbColumn;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leadingWidth: 100,
            leading: GestureDetector(
              onTap: _isLoading ? null : () => Navigator.of(context).pop(),
              child: Row(
                children: const [
                  SizedBox(width: 15),
                  Icon(Icons.arrow_back, color: Colors.black, size: 20),
                  SizedBox(width: 10),
                  Text(
                    'Back',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: TextButton.icon(
                  onPressed: _isLoading ? null : _showLogoutDialog,
                  icon: Icon(Icons.logout, color: _isLoading ? Colors.grey : Colors.redAccent, size: 20),
                  label: Text(
                    'Log out',
                    style: TextStyle(
                      color: _isLoading ? Colors.grey : Colors.redAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 1, thickness: 0.5),
                const SizedBox(height: 15),
                const Text(
                  'Account',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 28,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Manage your personal information',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ),
                const SizedBox(height: 30),

                // --- AVATAR SECTION ---
                Center(
                  child: GestureDetector(
                    onTap: _isLoading ? null : _pickImage,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: const Color(0xFF005DA1).withOpacity(0.1),
                          backgroundImage: _profileImageUrl != null && _profileImageUrl!.isNotEmpty
                              ? NetworkImage(_profileImageUrl!)
                              : null,
                          child: _profileImageUrl == null || _profileImageUrl!.isEmpty
                              ? Text(
                            _firstName.isNotEmpty ? _firstName[0].toUpperCase() : "U",
                            style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF005DA1)
                            ),
                          )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                                color: const Color(0xFF005DA1),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3),
                                boxShadow: [
                                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)
                                ]
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                const Divider(height: 1, thickness: 0.5),
                _buildAccountOption(
                    title: 'First Name', value: _firstName, icon: Icons.person_outline,
                    onTap: () => _showEditDialog("First Name", _firstName, 'firstName')
                ),
                const Divider(height: 1, thickness: 0.5),
                _buildAccountOption(
                    title: 'Last Name', value: _lastName, icon: Icons.person_outline,
                    onTap: () => _showEditDialog("Last Name", _lastName, 'LastName')
                ),
                const Divider(height: 1, thickness: 0.5),
                _buildAccountOption(
                    title: 'Phone Number', value: _phone, icon: Icons.phone_android_outlined,
                    onTap: () => _showEditDialog("Phone Number", _phone, 'PhoneNumber')
                ),
                const Divider(height: 1, thickness: 0.5),
                _buildAccountOption(
                    title: 'Email',
                    value: _email,
                    icon: Icons.email_outlined,
                    onTap: () => _showReadOnlyDialog("Email Address", _email),
                    isEditable: false
                ),
                const Divider(height: 1, thickness: 0.5),
                _buildAccountOption(
                    title: 'Age', value: _age, icon: Icons.cake_outlined,
                    onTap: () => _showEditDialog("Age", _age, 'Age')
                ),
                const Divider(height: 1, thickness: 0.5),
                _buildAccountOption(
                    title: 'Height', value: "$_height cm", icon: Icons.height,
                    onTap: () => _showEditDialog("Height (cm)", _height, 'Height')
                ),
                const Divider(height: 1, thickness: 0.5),
                _buildAccountOption(
                    title: 'Weight', value: "$_weight kg", icon: Icons.monitor_weight_outlined,
                    onTap: () => _showEditDialog("Weight (kg)", _weight, 'Weight')
                ),
                const Divider(height: 1, thickness: 0.5),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),

        // --- PROFESSIONAL LOADING OVERLAY (FIXED) ---
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Material( // <--- Added Material widget here to fix the yellow line
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF005DA1)),
                        strokeWidth: 3,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Updating...",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF005DA1),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAccountOption({
    required String title,
    required String value,
    required VoidCallback onTap,
    required IconData icon,
    bool isEditable = true,
  }) {
    return InkWell(
      onTap: _isLoading ? null : onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF005DA1).withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF005DA1), size: 22),
            ),
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.fade,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 10),
            if (isEditable)
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14)
            else
              const SizedBox(width: 14),
          ],
        ),
      ),
    );
  }
}