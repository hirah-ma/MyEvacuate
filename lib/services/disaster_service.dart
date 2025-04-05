import 'package:google_maps_flutter/google_maps_flutter.dart';

class DisasterService {
  static Future<List<String>> getDisasterAlerts(LatLng location) async {
    // Replace with actual API call to USGS, NASA FIRMS, etc.
    await Future.delayed(Duration(seconds: 2)); // simulate network delay

    return [
      "⚠️ Wildfire Alert near your area!",
      "🚨 Earthquake detected 20km from you",
      "🌧️ Flood warning in effect"
    ];
  }
}
