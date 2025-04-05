import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  static Future<LatLng> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.requestPermission();

    if (serviceEnabled && (permission == LocationPermission.always || permission == LocationPermission.whileInUse)) {
      Position pos = await Geolocator.getCurrentPosition();
      return LatLng(pos.latitude, pos.longitude);
    }

    return LatLng(0, 0); // fallback
  }
}
