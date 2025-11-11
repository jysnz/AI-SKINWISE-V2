import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Scanner_Page/ScannerPage.dart';
import '../History_Page/HistoryPage.dart';
import '../Messages_Page/MessagesPage.dart';
import 'DashboardContent.dart'; // <-- Correct import

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

// NO MODELS HERE
// ...

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    const DashboardContent(), // <-- This is your dashboard screen
    const Scannerpage(),
    const Messagespage(),
    const Historypage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // ... (rest of your build methods for icons)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: Container(
        // ... (rest of your BottomNavigationBar code)
      ),
    );
  }
}