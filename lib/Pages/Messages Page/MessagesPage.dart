import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Messagespage extends StatefulWidget {
  const Messagespage({super.key});

  @override
  State<Messagespage> createState() => _MessagespageState();
}

class _MessagespageState extends State<Messagespage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
          child: Text("This is the messages page")
      ),
    );
  }
}
