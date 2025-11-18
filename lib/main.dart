import 'package:ai_skinwise_v2/Pages/Clinic%20Page/Fee.dart';
import 'package:ai_skinwise_v2/Pages/Clinic%20Page/Findclinic.dart';
import 'package:ai_skinwise_v2/Pages/Clinic%20Page/Freeconsult.dart';
import 'package:ai_skinwise_v2/Pages/Clinic%20Page/Freemess.dart';
import 'package:ai_skinwise_v2/Pages/Clinic%20Page/Nauravailable.dart';
import 'package:ai_skinwise_v2/Pages/Clinic%20Page/Rekwes.dart';
import 'package:ai_skinwise_v2/Pages/Clinic%20Page/Schedulefee.dart';
import 'package:ai_skinwise_v2/Pages/History_Page/ArchiveScreenContainer.dart'; // <--- Ito lang ang kailangan

import 'package:ai_skinwise_v2/Pages/LoginSignInPage/Code.dart';
import 'package:ai_skinwise_v2/Pages/LoginSignInPage/CreateAccount.dart';
import 'package:ai_skinwise_v2/Pages/LoginSignInPage/Login.dart';
import 'package:ai_skinwise_v2/Pages/LoginSignInPage/Reqpass.dart';
import 'package:ai_skinwise_v2/Pages/LoginSignInPage/Update.dart';
import 'package:ai_skinwise_v2/Pages/LoginSignInPage/personalinfo.dart';
import 'package:ai_skinwise_v2/Pages/LoginSignInPage/verify.dart';
import 'package:ai_skinwise_v2/Pages/LoginSignInPage/Fillupemail.dart';
import 'package:ai_skinwise_v2/Pages/StartPage.dart';
import 'package:flutter/material.dart';
// Import your pages from their new locations
import 'Pages/Dashboard_Page/Homepage.dart';
import 'Pages/Scanner_Page/DetectionInformation.dart';
import 'Pages/Scanner_Page/CameraScanner.dart';
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
          seedColor: const Color(0xFF007BFF),
          primary: const Color(0xFF007BFF),
          secondary: const Color(0xFF17A2B8),
        ),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Inter',
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
      // Ito ang tama, dahil ArchiveScreenContainer ang naglalaman ng buong History/Archive page.
      // FIX: Set the home property to your main page.
      home: Nauravailable(),

      routes: {'/scanner': (context) => const Camerascanner()},
    );
  }
}
