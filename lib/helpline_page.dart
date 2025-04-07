import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelplinePage extends StatelessWidget {
  final List<Map<String, String>> helplines = [
    {'name': 'Fire Department', 'number': '1-800-555-1234'},
    {'name': 'Ambulance', 'number': '1-800-555-5678'},
    {'name': 'Police', 'number': '1-800-555-9876'},
    {'name': 'Wildlife Rescue', 'number': '1-800-555-8765'},
    {'name': 'Disaster Relief', 'number': '1-800-555-6543'},
    {'name': 'Evacuation Support', 'number': '1-800-555-4321'},
    {'name': 'Health Advisory', 'number': '1-800-555-3210'},
    {'name': 'Volunteer Support', 'number': '1-800-555-2109'},
    {'name': 'Emergency Supplies', 'number': '1-800-555-1098'},
  ];

  // Function to launch the phone dialer
  Future<void> _launchPhone(String number) async {
    final Uri url = Uri(scheme: 'tel', path: number);
    if (await canLaunch(url.toString())) {
      await launch(url.toString());
    } else {
      throw 'Could not launch $number';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Emergency Helpline Services"),
        backgroundColor: Colors.red[100],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: helplines.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(
                helplines[index]['name']!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Call: ${helplines[index]['number']}'),
              trailing: Icon(Icons.phone, color: Colors.red),
              onTap: () {
                _launchPhone(helplines[index]['number']!); // Calling functionality
              },
            ),
          );
        },
      ),
    );
  }
}
