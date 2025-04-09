import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xml/xml.dart' as xml;
import 'package:flutter/services.dart' show rootBundle;

/// This function parses the `layer.kml` file and uploads house data in the format:
/// {
///   "name": "House 1",
///   "location": { "lat": <latitude>, "lng": <longitude> },
///   "status": "<randomly choose: 'On Fire', 'Safe', or 'Under Control'>"
/// }
Future<void> uploadHousesFromKML() async {
  try {
    final kmlString = await rootBundle.loadString('assets/layer.kml');
    final document = xml.XmlDocument.parse(kmlString);
    final placemarks = document.findAllElements('Placemark');

    final statuses = ['On Fire', 'Safe', 'Under Control'];
    final random = Random();

    for (var placemark in placemarks) {
      final nameElement = placemark.getElement('name');
      final polygonElement = placemark.findAllElements('coordinates').firstOrNull;

      if (nameElement == null || polygonElement == null) continue;

      final name = nameElement.text.trim();
      final rawCoordinates = polygonElement.text.trim();

      final coordinates = rawCoordinates
          .split(RegExp(r'\s+'))
          .where((c) => c.isNotEmpty)
          .map((coordString) {
        final parts = coordString.split(',');
        if (parts.length >= 2) {
          return {
            'lat': double.parse(parts[1]),
            'lng': double.parse(parts[0]),
          };
        } else {
          return null;
        }
      })
          .whereType<Map<String, double>>()
          .toList();

      if (coordinates.isEmpty) continue;

      final location = coordinates.first;
      final status = statuses[random.nextInt(statuses.length)];

      await FirebaseFirestore.instance.collection('kml_houses').add({
        'name': name,
        'location': location,
        'status': status,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('✅ Uploaded $name at ${location['lat']}, ${location['lng']} with status: $status');
    }
  } catch (e) {
    print('❌ Error uploading KML data: $e');
    rethrow;
  }
}
