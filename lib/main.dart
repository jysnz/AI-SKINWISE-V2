import 'package:ai_skinwise_v2/Pages/Dashboard%20Page/Homepage.dart';
import 'package:flutter/material.dart';
import 'package:ai_skinwise_v2/Pages/StartPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = <Widget>[
      Center(child: Text('Home Page')),
      Center(child: Text('Search Page')),
      Center(child: Text('Profile Page')),
    ];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI-SKINWISE',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Homepage(),
    );
  }
}

