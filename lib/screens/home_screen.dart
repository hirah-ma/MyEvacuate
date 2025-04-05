import 'package:flutter/material.dart';
import 'alerts_screen.dart';
import 'map_screen.dart';
import 'routes_screen.dart';
import 'tips_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MyEvacuate')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("Navigate safely during natural disasters."),
            SizedBox(height: 30),
            _buildNavButton(context, "🚨 Real-Time Alerts", AlertsScreen()),
            _buildNavButton(context, "🗺️ Risk Map", MapScreen()),
            _buildNavButton(context, "🧭 Evacuation Routes", RoutesScreen()),
            _buildNavButton(context, "📘 Safety Tips", TipsScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, String title, Widget screen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[850],
          padding: EdgeInsets.symmetric(vertical: 16),
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => screen),
        ),
        child: Text(title, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
