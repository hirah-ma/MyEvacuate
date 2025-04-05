import 'package:flutter/material.dart';

class TipsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Safety Tips")),
      body: Center(
        child: Text(
          "Disaster-specific safety tips will be added.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
