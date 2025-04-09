import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelplinePage extends StatelessWidget {
  final List<Map<String, String>> helplines = [
    {'name': 'Fire Department', 'number': '+18005551234'},
    {'name': 'Ambulance', 'number': '+18005555678'},
    {'name': 'Police', 'number': '+18005559876'},
    {'name': 'Wildlife Rescue', 'number': '+18005558765'},
    {'name': 'Disaster Relief', 'number': '+18005556543'},
    {'name': 'Evacuation Support', 'number': '+18005554321'},
    {'name': 'Health Advisory', 'number': '+18005553210'},
    {'name': 'Volunteer Support', 'number': '+18005552109'},
    {'name': 'Emergency Supplies', 'number': '+18005551098'},
  ];

  // Function to launch the phone dialer
  Future<void> _launchPhone(String number) async {
    final Uri url = Uri(scheme: 'tel', path: number);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch dialer for $number';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Helpline Services"),
        backgroundColor: Colors.red[100],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: helplines.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(
                helplines[index]['name']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Call: ${helplines[index]['number']}'),
              trailing: const Icon(Icons.phone, color: Colors.red),
              onTap: () {
                _launchPhone(helplines[index]['number']!);
              },
            ),
          );
        },
      ),
    );
  }
}
