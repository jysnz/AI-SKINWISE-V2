import 'package:ai_skinwise_v2/Pages/History_Page/Archive.dart';
import 'package:ai_skinwise_v2/Pages/History_Page/HistoryInterface.dart';
import 'package:ai_skinwise_v2/Pages/LoginSignInPage/Code.dart';
import 'package:ai_skinwise_v2/Pages/LoginSignInPage/CreateAccount.dart';
import 'package:ai_skinwise_v2/Pages/LoginSignInPage/Login.dart';
import 'package:ai_skinwise_v2/Pages/LoginSignInPage/Reqpass.dart';
import 'package:ai_skinwise_v2/Pages/LoginSignInPage/Update.dart';
import 'package:ai_skinwise_v2/Pages/LoginSignInPage/personalinfo.dart';
import 'package:ai_skinwise_v2/Pages/LoginSignInPage/verify.dart';
import 'package:ai_skinwise_v2/Pages/LoginSignInPage/Fillupemail.dart';
import 'package:flutter/material.dart';
// Import your pages from their new locations
import 'Pages/Dashboard_Page/Homepage.dart';
import 'Pages/Scanner_Page/DetectionInformation.dart';
import 'Pages/Scanner_Page/CameraScanner.dart';
import 'Pages/StartPage.dart';
import 'Supabase/supabase_config.dart';
import 'Supabase/user_data_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeSupabase();
  runApp(const MyApp());
  fetchUserDataAndPrintToConsole();
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
      home: const Startpage(),
      // We can also define routes for navigation
      routes: {
        '/scanner': (context) => const Camerascanner(),
      },
    );
  }
}