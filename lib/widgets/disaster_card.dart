import 'package:flutter/material.dart';

class DisasterCard extends StatelessWidget {
  final String alert;

  DisasterCard({required this.alert});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      color: Colors.red[400],
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Text(
          alert,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
