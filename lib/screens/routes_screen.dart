import 'package:flutter/material.dart';

class RoutesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Evacuation Routes")),
      body: Center(
        child: Text(
          "Safest routes will be displayed here!",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
