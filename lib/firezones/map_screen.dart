import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Set<Polygon> _polygons = {};
  final Set<Circle> _circles = {};
  final Set<Polyline> _polylines = {};

  late GoogleMapController _mapController;
  LatLng? _currentPosition;

  final String _googleMapsApiKey = 'YOUR_API_KEY_HERE'; // <-- Replace with your key

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadSafePointsAsSquares();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
        return;
      }
    }

    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _circles.add(Circle(
        circleId: const CircleId('user_location'),
        center: _currentPosition!,
        radius: 2,
        fillColor: Colors.blue.withOpacity(0.3),
        strokeColor: Colors.black,
        strokeWidth: 1,
      ));
    });
  }

  void _loadSafePointsAsSquares() async {
    final snapshot = await FirebaseFirestore.instance.collection('kml_houses').get();

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final LatLng center = LatLng(data['location']['lat'], data['location']['lng']);
      final String name = data['location']['name'] ?? 'Unknown';
      final String status = data['location']['status'] ?? 'Unknown';

      const double delta = 0.0003;
      List<LatLng> squarePoints = [
        LatLng(center.latitude - delta, center.longitude - delta),
        LatLng(center.latitude - delta, center.longitude + delta),
        LatLng(center.latitude + delta, center.longitude + delta),
        LatLng(center.latitude + delta, center.longitude - delta),
      ];

      _polygons.add(
        Polygon(
          polygonId: PolygonId('point_$name'),
          points: squarePoints,
          fillColor: status.toLowerCase() == 'safe'
              ? Colors.green.withOpacity(0.5)
              : Colors.red.withOpacity(0.5),
          strokeColor: Colors.black,
          strokeWidth: 1,
        ),
      );
    }

    setState(() {});
  }

  bool _isInsideFirezone(LatLng point) {
    for (var polygon in _polygons) {
      if (polygon.fillColor == Colors.red.withOpacity(0.5)) {
        if (_pointInPolygon(point, polygon.points)) {
          return true;
        }
      }
    }
    return false;
  }

  bool _pointInPolygon(LatLng point, List<LatLng> polygon) {
    int intersectCount = 0;
    for (int j = 0; j < polygon.length - 1; j++) {
      LatLng p1 = polygon[j];
      LatLng p2 = polygon[j + 1];
      if ((p1.latitude > point.latitude) != (p2.latitude > point.latitude)) {
        double atX = (p2.longitude - p1.longitude) *
            (point.latitude - p1.latitude) /
            (p2.latitude - p1.latitude) +
            p1.longitude;
        if (point.longitude < atX) intersectCount++;
      }
    }
    return (intersectCount % 2 == 1);
  }

  Future<LatLng?> _getNearestSafePoint() async {
    final snapshot = await FirebaseFirestore.instance.collection('kml_houses').get();
    double minDistance = double.infinity;
    LatLng? nearest;

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final String status = data['location']['status'] ?? 'unknown';
      if (status.toLowerCase() == 'safe') {
        final LatLng point = LatLng(data['location']['lat'], data['location']['lng']);
        final double distance = Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          point.latitude,
          point.longitude,
        );
        if (distance < minDistance) {
          minDistance = distance;
          nearest = point;
        }
      }
    }
    return nearest;
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  Future<List<LatLng>> _getRoute(LatLng origin, LatLng destination) async {
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&mode=walking&key=$_googleMapsApiKey';

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    if (data['routes'].isEmpty) return [];

    final encodedPolyline = data['routes'][0]['overview_polyline']['points'];
    return _decodePolyline(encodedPolyline);
  }

  Future<void> _routeUserToSafety() async {
    if (_currentPosition == null) return;

    bool inside = _isInsideFirezone(_currentPosition!);
    if (!inside) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You are not in a firezone.")),
      );
      return;
    }

    final nearest = await _getNearestSafePoint();
    if (nearest == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No safe points found.")),
      );
      return;
    }

    final route = await _getRoute(_currentPosition!, nearest);

    setState(() {
      _polylines.clear();
      _polylines.add(Polyline(
        polylineId: const PolylineId('evacuation_route'),
        points: route,
        color: Colors.blue,
        width: 5,
      ));
    });

    _mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
            route.map((e) => e.latitude).reduce((a, b) => a < b ? a : b),
            route.map((e) => e.longitude).reduce((a, b) => a < b ? a : b),
          ),
          northeast: LatLng(
            route.map((e) => e.latitude).reduce((a, b) => a > b ? a : b),
            route.map((e) => e.longitude).reduce((a, b) => a > b ? a : b),
          ),
        ),
        50,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('House Fire Map')),
      body: GoogleMap(
        onMapCreated: (controller) => _mapController = controller,
        initialCameraPosition: CameraPosition(
          target: _currentPosition!,
          zoom: 14,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        polygons: _polygons,
        circles: _circles,
        polylines: _polylines,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _routeUserToSafety,
        label: const Text("Evacuate Safely"),
        icon: const Icon(Icons.directions_walk),
      ),
    );
  }
}
