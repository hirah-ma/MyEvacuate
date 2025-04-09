import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wildfire/locationhelper/location_helper.dart';// Import your existing LocationHelper

class FireApiService {
  static const String baseUrl = 'http://10.0.2.2:5000'; // for Android emulator

  /// 🔥 Step 1: Send user's lat/lon to Flask & receive nearby fire points
  static Future<List<Map<String, dynamic>>> getNearbyFires(double lat, double lon) async {
    final url = Uri.parse('$baseUrl/nearby');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'latitude': lat, 'longitude': lon}),
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load fire data');
    }
  }

  /// 🗺️ Step 2: Fetch fires & build Google Map markers
  static Future<Set<Marker>> fetchAndShowFires() async {
    final locationData = await LocationHelper().getUserLocation();
    if (locationData == null) {
      print('❌ Location unavailable');
      return {};
    }

    double lat = locationData['latitude'];
    double lon = locationData['longitude'];

    try {
      List<Map<String, dynamic>> fires = await getNearbyFires(lat, lon);

      Set<Marker> markers = fires.map((fire) {
        return Marker(
          markerId: MarkerId('${fire['latitude']}_${fire['longitude']}'),
          position: LatLng(fire['latitude'], fire['longitude']),
          infoWindow: InfoWindow(title: '🔥 Fire detected'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        );
      }).toSet();

      return markers;
    } catch (e) {
      print('🔥 Error fetching fires: $e');
      return {};
    }
  }
}
