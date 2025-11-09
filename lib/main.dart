import 'package:flutter/material.dart';
// Import your pages from their new locations
import 'Pages/Dashboard_Page/Homepage.dart';
import 'Pages/Scanner_Page/DetectionInformation.dart';
import 'Pages/Scanner_Page/CameraScanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Skin App Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF007BFF), // A blue matching the buttons
          primary: const Color(0xFF007BFF),
          secondary: const Color(0xFF17A2B8), // The lighter blue
        ),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Inter', // A font similar to the design
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF007BFF),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      // The home is now the Detectioninformation page
      home: const Homepage(),
      // We can also define routes for navigation
      routes: {
        '/scanner': (context) => const Camerascanner(),
        '/home': (context) => const Homepage(),
      },
    );
  }
}