import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class Firezone {
  final String name;
  final String severity;
  final List<LatLng> coordinates;

  Firezone({
    required this.name,
    required this.severity,
    required this.coordinates,
  });

  // Create Firezone from Firestore document data
  factory Firezone.fromMap(Map<String, dynamic> data) {
    return Firezone(
      name: data['name'] ?? 'Unnamed',
      severity: data['severity'] ?? 'Low',
      coordinates: (data['coordinates'] as List).map((coord) {
        return LatLng(coord['lat'], coord['lng']);
      }).toList(),
    );
  }

  // Get color based on severity
  Color getColorBySeverity() {
    switch (severity.toLowerCase()) {
      case 'high':
        return Colors.red.withOpacity(0.5);
      case 'medium':
        return Colors.orange.withOpacity(0.5);
      case 'low':
        return Colors.yellow.withOpacity(0.5);
      default:
        return Colors.grey.withOpacity(0.5);
    }
  }
}
