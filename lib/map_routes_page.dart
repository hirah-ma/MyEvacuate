import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'firezones/firezone_dataset.dart';
import 'firezones/firezone_model.dart';
import 'alternate_map_page.dart';


class MapRoutesPage extends StatefulWidget {
  const MapRoutesPage({Key? key}) : super(key: key);

  @override
  State<MapRoutesPage> createState() => _MapRoutesPage();
}

class _MapRoutesPage extends State<MapRoutesPage> {
  final Set<Polygon> _polygons = {};
  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};
  late GoogleMapController _mapController;
  LatLng? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadSafePointsAsSquares();
    _fetchAndDrawFirezones();
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
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        return;
      }
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);

      _circles.add(
        Circle(
          circleId: const CircleId('user_location'),
          center: _currentPosition!,
          radius: 2,
          fillColor: Colors.blue.withOpacity(0.3),
          strokeColor: Colors.black,
          strokeWidth: 1,
        ),
      );

      _markers.add(
        Marker(
          markerId: const MarkerId('me'),
          position: _currentPosition!,
          infoWindow: const InfoWindow(title: 'You'),
        ),
      );
    });
  }

  Future<void> _loadSafePointsAsSquares() async {
    _polygons.removeWhere((p) => p.polygonId.value.startsWith('point_'));
    _markers.removeWhere((m) => m.markerId.value.startsWith('house_'));

    final snapshot =
    await FirebaseFirestore.instance.collection('kml_houses').get();

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final lat = data['location']?['lat'];
      final lng = data['location']?['lng'];
      final name = data['name'] ?? 'Unknown';
      final status = data['status'] ?? 'Unknown';

      if (lat == null || lng == null) continue;

      final LatLng center = LatLng(lat, lng);

      print('✅ Adding: $name at (${center.latitude}, ${center.longitude}) Status: $status');

      const double delta = 0.0001;
      List<LatLng> squarePoints = [
        LatLng(center.latitude - delta, center.longitude - delta),
        LatLng(center.latitude - delta, center.longitude + delta),
        LatLng(center.latitude + delta, center.longitude + delta),
        LatLng(center.latitude + delta, center.longitude - delta),
      ];

      Color fillColor;
      double hue;

      switch (status.toLowerCase()) {
        case 'safe':
          fillColor = Colors.green.withOpacity(0.5);
          hue = BitmapDescriptor.hueGreen;
          break;
        case 'under control':
          fillColor = Colors.orange.withOpacity(0.5);
          hue = BitmapDescriptor.hueOrange;
          break;
        default: // on fire or unknown
          fillColor = Colors.red.withOpacity(0.5);
          hue = BitmapDescriptor.hueRed;
      }

      _polygons.add(
        Polygon(
          polygonId: PolygonId('point_$name'),
          points: squarePoints,
          fillColor: fillColor,
          strokeColor: Colors.black,
          strokeWidth: 1,
        ),
      );

      _markers.add(
        Marker(
          markerId: MarkerId('house_$name'),
          position: center,
          infoWindow: InfoWindow(
            title: name,
            snippet: 'Status: $status',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(hue),
        ),
      );
    }

    setState(() {});
  }

  Future<void> _fetchAndDrawFirezones() async {
    List<Firezone> firezones = await FirezoneDataset.getFirezones();

    if (firezones.isEmpty) {
      print("❌ No firezones found.");
      return;
    }

    for (Firezone fz in firezones) {
      _polygons.add(
        Polygon(
          polygonId: PolygonId(fz.name),
          points: fz.coordinates,
          fillColor: fz.getColorBySeverity().withOpacity(0.4),
          strokeColor: fz.getColorBySeverity(),
          strokeWidth: 2,
        ),
      );

      LatLng center = _getPolygonCenter(fz.coordinates);
      _markers.add(
        Marker(
          markerId: MarkerId("firezone_${fz.name}"),
          position: center,
          infoWindow: InfoWindow(
            title: fz.name,
            snippet: "Severity: ${fz.severity}",
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            fz.severity == "high"
                ? BitmapDescriptor.hueRed
                : fz.severity == "medium"
                ? BitmapDescriptor.hueOrange
                : BitmapDescriptor.hueYellow,
          ),
        ),
      );
    }

    setState(() {});
  }

  LatLng _getPolygonCenter(List<LatLng> points) {
    double lat = 0;
    double lng = 0;
    for (var p in points) {
      lat += p.latitude;
      lng += p.longitude;
    }
    return LatLng(lat / points.length, lng / points.length);
  }
  bool _isAlternateMap = false;

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fire Evacuation Map'),
        actions: [
          Row(
            children: [
              const Text('Simple Map', style: TextStyle(fontSize: 16)),
              Switch(
                value: _isAlternateMap,
                onChanged: (value) {
                  setState(() => _isAlternateMap = value);
                  if (value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AlternateMapPage()),
                    );
                  }
                },
                activeColor: Colors.white,
              ),
            ],
          ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: (controller) => _mapController = controller,
        initialCameraPosition: CameraPosition(
          target: _currentPosition!,
          zoom: 14,
        ),
        myLocationEnabled: true,
        polygons: _polygons,
        markers: _markers,
        circles: _circles,
      ),
    );
  }

}
