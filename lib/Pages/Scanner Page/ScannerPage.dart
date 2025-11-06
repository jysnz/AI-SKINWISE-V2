import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Scannerpage extends StatefulWidget {
  const Scannerpage({super.key});

  @override
  State<Scannerpage> createState() => _ScannerpageState();
}

class _ScannerpageState extends State<Scannerpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
          child: Text("This is the scanner page")
      ),
    );
  }
}
