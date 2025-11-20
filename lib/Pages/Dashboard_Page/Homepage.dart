import 'package:ai_skinwise_v2/Pages/History_Page/HistoryInterface.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../Scanner_Page/ScannerPage.dart';
import '../Messages_Page/MessagesPage.dart';
import 'DashboardContent.dart';

class Homepage extends StatefulWidget {
  final String? email;

  const Homepage({
    super.key,
    this.email,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with WidgetsBindingObserver {
  int _selectedIndex = 0;

  // Variables to hold user data
  String _firstName = "Guest";
  Map<String, dynamic>? _fullUserData; // <--- This will hold ALL user info

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // 1. Set Online Status
    _updateOnlineStatus(true);

    // 2. Fetch ALL User Data
    _fetchUserData();
  }

  @override
  void dispose() {
    _updateOnlineStatus(false);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _updateOnlineStatus(true);
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      _updateOnlineStatus(false);
    }
  }

  // --- FETCH FULL USER DATA ---
  Future<void> _fetchUserData() async {
    if (widget.email == null) return;
    try {
      final data = await Supabase.instance.client
          .from('UserInformation')
          .select() // <--- Empty select() means "Select *" (Fetch All Columns)
          .eq('email', widget.email!)
          .maybeSingle();

      if (data != null && mounted) {
        setState(() {
          _fullUserData = data; // Store the entire dictionary of data
          _firstName = data['firstName'] ?? "Guest"; // Extract name for UI
        });

        // Debug: Print all data to console to prove it worked
        print("✅ Full User Data Loaded: $_fullUserData");
      }
    } catch (e) {
      print("❌ Error fetching user data: $e");
    }
  }

  // --- ONLINE STATUS LOGIC ---
  Future<void> _updateOnlineStatus(bool isOnline) async {
    if (widget.email == null || widget.email!.isEmpty) return;

    try {
      await Supabase.instance.client
          .from('UserInformation')
          .update({'is_online': isOnline})
          .eq('email', widget.email!);
    } catch (e) {
      print("Error updating online status: $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildActiveIcon(String assetName, String label, double width, double height) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF005DA1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Image.asset(
            assetName,
            width: width,
            height: height,
            color: Colors.white,
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildInactiveIcon(String assetName, String label, double width, double height) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      color: Colors.transparent,
      child: Column(
        children: [
          Image.asset(
            assetName,
            width: width,
            height: height,
            color: const Color(0xFF005DA1),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Color(0xFF005DA1), fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // You can now pass _firstName to DashboardContent
    final List<Widget> screens = [
      DashboardContent(
        firstName: _firstName,
        userData: _fullUserData,
        onRefresh: _fetchUserData, // <--- PASSING THE REFRESH FUNCTION HERE
      ),
      const Scannerpage(),
      const Messagespage(),
      const Historyinterface(),
    ];

    return Scaffold(
      appBar: null,
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color(0xFF005DA1),
              width: 1.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: _buildInactiveIcon('Icons/Home_Icon.png', 'Home', 20.5, 20),
              activeIcon: _buildActiveIcon('Icons/Home_Icon.png', 'Home', 20.5, 20),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildInactiveIcon('Icons/Scan_Icon.png', 'Scanner', 19.49, 21),
              activeIcon: _buildActiveIcon('Icons/Scan_Icon.png', 'Scanner', 19.49, 21),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildInactiveIcon('Icons/Message_Icon.png', 'Message', 21.52, 19),
              activeIcon: _buildActiveIcon('Icons/Message_Icon.png', 'Message', 21.52, 19),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildInactiveIcon('Icons/History_Icon.png', 'History', 21.32, 20.8),
              activeIcon: _buildActiveIcon('Icons/History_Icon.png', 'History', 21.32, 20.8),
              label: '',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}