import 'package:cloud_firestore/cloud_firestore.dart';
import 'firezone_dataset.dart';

class FirezoneUploader {
  static Future<void> uploadSampleData() async {
    for (var zone in largeFirezoneData) {
      await FirebaseFirestore.instance.collection('firezones').add(zone);
    }
    print("🔥 Large firezones uploaded!");
  }
}
