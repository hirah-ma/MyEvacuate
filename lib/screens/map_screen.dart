import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Risk Map")),
      body: Center(
        child: Text(
          "Live Risk Map Coming Soon!",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
