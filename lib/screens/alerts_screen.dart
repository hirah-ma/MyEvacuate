import 'package:flutter/material.dart';

class AlertsScreen extends StatelessWidget {
  final List<Map<String, String>> dummyAlerts = [
    {
      "type": "Earthquake",
      "location": "20km NE of Guwahati, Assam",
      "magnitude": "4.6",
      "time": "2025-04-06 10:34 AM"
    },
    {
      "type": "Flood",
      "location": "Patna, Bihar",
      "severity": "Severe",
      "time": "2025-04-05 11:20 AM"
    },
    {
      "type": "Cyclone",
      "location": "Odisha Coastline",
      "severity": "Very Severe",
      "time": "2025-04-04 03:00 PM"
    },
    {
      "type": "Heatwave",
      "location": "Delhi NCR",
      "severity": "Extreme",
      "time": "2025-04-06 01:00 PM"
    },
  ];

  IconData _getIcon(String type) {
    switch (type) {
      case "Earthquake":
        return Icons.waves;
      case "Flood":
        return Icons.water;
      case "Cyclone":
        return Icons.air;
      case "Heatwave":
        return Icons.thermostat;
      default:
        return Icons.warning;
    }
  }

  Color _getColor(String type) {
    switch (type) {
      case "Earthquake":
        return Colors.orange;
      case "Flood":
        return Colors.blue;
      case "Cyclone":
        return Colors.green;
      case "Heatwave":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("⚠️ Real-Time Alerts (Demo)")),
      body: ListView.builder(
        itemCount: dummyAlerts.length,
        itemBuilder: (context, index) {
          final alert = dummyAlerts[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Icon(
                _getIcon(alert['type']!),
                color: _getColor(alert['type']!),
                size: 30,
              ),
              title: Text("${alert['type']} in ${alert['location']}"),
              subtitle: Text("Time: ${alert['time']}"),
              trailing: alert.containsKey("magnitude")
                  ? Text("Mag: ${alert['magnitude']}")
                  : Text("${alert['severity']}"),
            ),
          );
        },
      ),
    );
  }
}
