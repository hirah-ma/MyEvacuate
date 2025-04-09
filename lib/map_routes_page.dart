import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'fire/fire_api_service.dart';
import 'locationhelper/location_helper.dart';

class MapRoutesPage extends StatefulWidget {
  @override
  _MapRoutesPageState createState() => _MapRoutesPageState();
}

class _MapRoutesPageState extends State<MapRoutesPage> {
  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  LatLng _initialPosition = LatLng(20.5937, 78.9629); // Default to India
  bool _loading = true;
  bool _hasError = false;
  BitmapDescriptor? _fireIcon;

  @override
  void initState() {
    super.initState();
    _loadMapData();
    _loadCustomIcon();
  }

  Future<void> _loadCustomIcon() async {
    _fireIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(20, 20)),
      'assets/fire.png',
    );
  }

  Future<void> _loadMapData() async {
    setState(() {
      _loading = true;
      _hasError = false;
    });

    final locationData = await LocationHelper().getUserLocation();

    if (locationData == null) {
      setState(() {
        _loading = false;
        _hasError = true;
      });
      return;
    }

    LatLng userLatLng = LatLng(locationData['latitude'], locationData['longitude']);
    _initialPosition = userLatLng;

    try {
      final fires = await FireApiService.getNearbyFires(
        userLatLng.latitude,
        userLatLng.longitude,
      );

      Set<Marker> fireMarkers = fires.map((fire) {
        return Marker(
          markerId: MarkerId('${fire['latitude']}_${fire['longitude']}'),
          position: LatLng(fire['latitude'], fire['longitude']),
          icon: _fireIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: '🔥 Fire Detected',
            snippet: 'Distance: ${fire['distance_km']} km',
          ),
        );
      }).toSet();

      setState(() {
        _markers = fireMarkers;
        _loading = false;
      });
    } catch (e) {
      print('🔥 Error: $e');
      setState(() {
        _loading = false;
        _hasError = true;
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    _controller?.animateCamera(CameraUpdate.newLatLngZoom(_initialPosition, 10));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fire Map")),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _hasError
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('❌ Failed to load data'),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loadMapData,
              child: Text('Retry 🔄'),
            ),
          ],
        ),
      )
          : GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 10,
        ),
        markers: _markers,
        mapType: MapType.normal,
      ),
    );
  }
}

