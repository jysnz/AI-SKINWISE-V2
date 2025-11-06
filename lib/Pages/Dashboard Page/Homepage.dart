import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Scanner Page/ScannerPage.dart';
import '../History Page/HistoryPage.dart';
import '../Messages Page/MessagesPage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Center(
      child: Text("This is the homepage"),
    ),
    Scannerpage(),
    Messagespage(),
    Historypage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildActiveIcon(String assetName, String label, double width, double height) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      decoration: BoxDecoration(
        color: Color(0xFF005DA1),
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
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInactiveIcon(String assetName, String label, double width, double height) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      color: Colors.transparent,
      child: Column(
        children: [
          Image.asset(
            assetName,
            width: width,
            height: height,
            color: Color(0xFF005DA1),
          ),
          SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: Color(0xFF005DA1),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
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
              icon: _buildInactiveIcon('Icons/Home Icon.png', 'Home', 28.5, 28),
              activeIcon: _buildActiveIcon('Icons/Home Icon.png', 'Home', 28.5, 28),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildInactiveIcon('Icons/Scan Icon.png', 'Scanner', 27.49, 29),
              activeIcon: _buildActiveIcon('Icons/Scan Icon.png', 'Scanner', 27.49, 29),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildInactiveIcon('Icons/Message Icon.png', 'Message', 29.52, 27),
              activeIcon: _buildActiveIcon('Icons/Message Icon.png', 'Message', 29.52, 27),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildInactiveIcon('Icons/History Icon.png', 'History', 29.32, 28.8),
              activeIcon: _buildActiveIcon('Icons/History Icon.png', 'History', 29.32, 28.8),
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