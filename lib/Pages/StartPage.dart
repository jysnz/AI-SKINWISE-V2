import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: [Color(0xFF2E7EC2), Color(0xFF50B6D0)],
                      begin: Alignment.topLeft,
                      end: Alignment.topRight
                    ).createShader(bounds);
                  },
                  child: Text(
                    "AI-SKINWISE",
                    style: GoogleFonts.rozhaOne(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                        colors: [Color(0xFF2E7EC2), Color(0xFF50B6D0)],
                        begin: Alignment.topLeft,
                        end: Alignment.topRight
                    ).createShader(bounds);
                  },
                  child: Text(
                    "Scan, Detect, Protect",
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50
                ),
                Container(
                  width: 300,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2E7EC2), Color(0xFF50B6D0)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      "Sign in",
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    height: 10
                ),
                Container(
                  width: 300,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2E7EC2), Color(0xFF50B6D0)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      "Sign up",
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ]
            )
          )
        ],
      ),
    );
  }
}