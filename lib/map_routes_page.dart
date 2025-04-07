import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapRoutesPage extends StatefulWidget {
  @override
  _MapRoutesPageState createState() => _MapRoutesPageState();
}

class _MapRoutesPageState extends State<MapRoutesPage> {
  // Create a controller to interact with the map
  GoogleMapController? _controller;

  // Initial camera position
  final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194), // San Francisco's coordinates
    zoom: 12,
  );

  // Function to handle map creation
  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map Routes"),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: _initialPosition,
        mapType: MapType.normal,
      ),
    );
  }
}
