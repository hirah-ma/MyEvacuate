import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'location_helper.dart';

class LocationFirestoreService {
  final LocationHelper locationHelper = LocationHelper();

  /// Gets the current user's location and stores it in Firestore
  Future<void> storeUserLocation() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print('⚠️ No user logged in');
        return;
      }

      final locationData = await locationHelper.getUserLocation();

      if (locationData == null) {
        print('❌ Could not fetch location');
        return;
      }

      await FirebaseFirestore.instance.collection('user_locations').doc(user.uid).set({
        'latitude': locationData['latitude'],
        'longitude': locationData['longitude'],
        'city': locationData['city'],
        'country': locationData['country'],
        'address': locationData['address'],
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('✅ Location saved for user: ${user.email}');
    } catch (e) {
      print('🔥 Error saving location: $e');
    }
  }
}
