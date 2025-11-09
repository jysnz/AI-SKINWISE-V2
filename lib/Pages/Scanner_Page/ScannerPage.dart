import 'package:ai_skinwise_v2/Pages/Scanner_Page/CameraScanner.dart';
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
        child: Column(
          // 3. This makes the Column only as tall as its children (the buttons)
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 330,
              height: 49.57,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Camerascanner()), // 1. Replace this
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFEFEFEF),
                    side: BorderSide(
                      width: 0.5, // The thickness
                      color: Colors.black// The outline color
                    ),
                  ),

                  child: Text("Take a photo",
                    style: TextStyle(
                        color: Color(0xFF0B6FB8),
                        fontSize: 15,
                        fontWeight: FontWeight.w600
                    ),
                  )),
            ),

            // 4. Add some space between the buttons
            SizedBox(height: 16),

            SizedBox(
              width: 330,
              height: 49.57,
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0B6FB8),
                  ),
                  child: Text("Upload a photo",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}