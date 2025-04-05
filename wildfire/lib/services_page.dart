import 'package:flutter/material.dart';

class ServicesPage extends StatelessWidget {
  final List<Map<String, String>> services = [
    {'name': 'Shelter', 'description': 'Emergency shelter available nearby.'},
    {'name': 'Healthcare', 'description': 'Nearby hospitals and clinics.'},
    {'name': 'Food', 'description': 'Food and water supply centers.'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: services.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(10),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text(
              services[index]['name']!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(services[index]['description']!),
            leading: Icon(Icons.local_hospital, color: Colors.red),
          ),
        );
      },
    );
  }
}
