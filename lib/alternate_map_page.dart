import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class AlternateMapPage extends StatefulWidget {
  @override
  State<AlternateMapPage> createState() => _AlternateMapPageState();
}

class _AlternateMapPageState extends State<AlternateMapPage> {
  bool _isAlternateMap = true;
  LatLng? userLatLng;
  Set<Marker> markers = {};
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    _loadUserLocationAndPoints();
  }

  Future<void> _loadUserLocationAndPoints() async {
    try {
      Position pos = await _getUserLocation();
      userLatLng = LatLng(pos.latitude, pos.longitude);

      // Add user marker
      Set<Marker> newMarkers = {
        Marker(
          markerId: MarkerId("user"),
          position: userLatLng!,
          infoWindow: InfoWindow(title: "You are here"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      };

      // Fetch nearby points from backend
      List<dynamic> points = await _fetchNearbyPoints(pos.latitude, pos.longitude);
      for (var point in points) {
        newMarkers.add(
          Marker(
            markerId: MarkerId(point['latitude'].toString()),
            position: LatLng(point['latitude'], point['longitude']),
            infoWindow: InfoWindow(
              title: 'Confidence: ${point['confidence'] ?? "N/A"}',
              snippet: '${point['distance_km']} km away',
            ),
          ),
        );
      }

      setState(() {
        markers = newMarkers;
      });

      // Move camera to user location
      if (mapController != null) {
        mapController.animateCamera(CameraUpdate.newLatLngZoom(userLatLng!, 8));
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<Position> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception("Location services are disabled.");

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permissions are denied.");
      }
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<List<dynamic>> _fetchNearbyPoints(double lat, double lon) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/nearby'), // Replace with IP if testing on real device
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'latitude': lat, 'longitude': lon}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load data from backend");
    }
  }

  @override
  Widget build(BuildContext context) {
    final LatLng fallbackCenter = LatLng(37.4219999, -122.0840575);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Map View'),
        actions: [
          Row(
            children: [
              const Text('Detailed Map', style: TextStyle(fontSize: 16)),
              Switch(
                value: _isAlternateMap,
                onChanged: (value) {
                  setState(() => _isAlternateMap = value);
                  if (!value) Navigator.pop(context); // Go back
                },
                activeColor: Colors.white,
              ),
            ],
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: userLatLng ?? fallbackCenter,
          zoom: 8,
        ),
        onMapCreated: (controller) {
          mapController = controller;
        },
        myLocationEnabled: true,
        markers: markers,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        onTap: (index) {
          // Navigation logic if needed
        },
      ),
    );
  }
}
