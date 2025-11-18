import 'package:ai_skinwise_v2/Pages/History_Page/ArchiveScreenContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Scanner_Page/ScannerPage.dart';
import '../Messages_Page/MessagesPage.dart';
import 'DashboardContent.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    DashboardContent(),
    const Scannerpage(),
    const Messagespage(),
    ArchiveScreenContainer(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildActiveIcon(
    String assetName,
    String label,
    double width,
    double height,
  ) {
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
          Text(label, style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildInactiveIcon(
    String assetName,
    String label,
    double width,
    double height,
  ) {
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
          Text(label, style: TextStyle(color: Color(0xFF005DA1), fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: IndexedStack(index: _selectedIndex, children: _widgetOptions),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFF005DA1), width: 1.0)),
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
              activeIcon: _buildActiveIcon(
                'Icons/Home_Icon.png',
                'Home',
                20.5,
                20,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildInactiveIcon(
                'Icons/Scan_Icon.png',
                'Scanner',
                19.49,
                21,
              ),
              activeIcon: _buildActiveIcon(
                'Icons/Scan_Icon.png',
                'Scanner',
                19.49,
                21,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildInactiveIcon(
                'Icons/Message_Icon.png',
                'Message',
                21.52,
                19,
              ),
              activeIcon: _buildActiveIcon(
                'Icons/Message_Icon.png',
                'Message',
                21.52,
                19,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildInactiveIcon(
                'Icons/History_Icon.png',
                'History',
                21.32,
                20.8,
              ),
              activeIcon: _buildActiveIcon(
                'Icons/History_Icon.png',
                'History',
                21.32,
                20.8,
              ),
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
