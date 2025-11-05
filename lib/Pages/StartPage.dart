import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Startpage extends StatefulWidget {
  const Startpage({super.key});

  @override
  State<Startpage> createState() => _StartpageState();
}

class _StartpageState extends State<Startpage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: null,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'Images/Stack1Bg.png',
            fit: BoxFit.cover,
          ),

          Align(
            alignment: Alignment.topCenter,
            child: Image.asset('Images/Stack2Bg.png'),
          ),

          Center(
            child: Image.asset('Images/Stack3Bg.png')
          ),

          Align (
            alignment: Alignment.topRight,
            child: Image.asset('Images/Stack4Bg.png')
          ),

          Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset('Images/Stack5Bg.png')
          ),

          Positioned(
            bottom: 20,
            left: 20,
            child: Image.asset('Images/Stack3Bg.png'),
          ),

          Container(
            margin: EdgeInsets.only(top: 225),
            child: Column(
              children: [
                Center(
                  child: Image.asset('Images/logo.png'),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "AI-SKINWISE"
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                    "Scan, Detect, Protect"
                ),
                SizedBox(
                  height: 50
                ),
                ElevatedButton(
                    onPressed: (){},
                    child: Text("Log in")
                ),
                ElevatedButton(
                    onPressed: (){},
                    child: Text("Sign up")
                ),
              ]
            )
          )
        ],
      ),
    );
  }
}