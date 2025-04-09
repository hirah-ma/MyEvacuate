import 'package:cloud_firestore/cloud_firestore.dart';
import 'firezone_model.dart';

class FirezoneDataset {
  static Future<List<Firezone>> getFirezones() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('firezones').get();

    return snapshot.docs.map((doc) {
      return Firezone.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }
}

final List<Map<String, dynamic>> largeFirezoneData = [
  // Your original 5 entries...
  {
    "name": "Griffith Park Fire",
    "severity": "High",
    "polygon": [
      {"lat": 34.136554, "lng": -118.294200},
      {"lat": 34.136890, "lng": -118.291859},
      {"lat": 34.135800, "lng": -118.290000},
      {"lat": 34.134287, "lng": -118.291238},
      {"lat": 34.134132, "lng": -118.293964},
      {"lat": 34.135000, "lng": -118.295400}
    ]
  },
  {
    "name": "Hollywood Hills Blaze",
    "severity": "Moderate",
    "polygon": [
      {"lat": 34.117300, "lng": -118.349000},
      {"lat": 34.118200, "lng": -118.345000},
      {"lat": 34.116900, "lng": -118.343100},
      {"lat": 34.115800, "lng": -118.346100},
      {"lat": 34.115700, "lng": -118.348800}
    ]
  },
  {
    "name": "Topanga Canyon Fire",
    "severity": "Critical",
    "polygon": [
      {"lat": 34.095000, "lng": -118.604000},
      {"lat": 34.096500, "lng": -118.600000},
      {"lat": 34.094000, "lng": -118.596000},
      {"lat": 34.091800, "lng": -118.598500},
      {"lat": 34.092900, "lng": -118.603500}
    ]
  },
  {
    "name": "Malibu Wildfire",
    "severity": "High",
    "polygon": [
      {"lat": 34.033000, "lng": -118.798000},
      {"lat": 34.034500, "lng": -118.793000},
      {"lat": 34.030000, "lng": -118.791000},
      {"lat": 34.028700, "lng": -118.795000},
      {"lat": 34.030900, "lng": -118.798500}
    ]
  },
  {
    "name": "Burbank Fire Threat",
    "severity": "Low",
    "polygon": [
      {"lat": 34.195000, "lng": -118.343000},
      {"lat": 34.197000, "lng": -118.339000},
      {"lat": 34.194000, "lng": -118.336000},
      {"lat": 34.191800, "lng": -118.338500},
      {"lat": 34.192900, "lng": -118.342500}
    ]
  },

  // 10 new entries below...
  {
    "name": "Echo Park Blaze",
    "severity": "Moderate",
    "polygon": [
      {"lat": 34.078900, "lng": -118.260000},
      {"lat": 34.080200, "lng": -118.256000},
      {"lat": 34.078300, "lng": -118.253000},
      {"lat": 34.076900, "lng": -118.256500},
      {"lat": 34.077400, "lng": -118.259000}
    ]
  },
  {
    "name": "Runyon Canyon Incident",
    "severity": "High",
    "polygon": [
      {"lat": 34.108000, "lng": -118.350000},
      {"lat": 34.109000, "lng": -118.347000},
      {"lat": 34.107000, "lng": -118.344000},
      {"lat": 34.106000, "lng": -118.347000},
      {"lat": 34.106500, "lng": -118.350000}
    ]
  },
  {
    "name": "Santa Monica Mountains Fire",
    "severity": "Critical",
    "polygon": [
      {"lat": 34.125000, "lng": -118.600000},
      {"lat": 34.126500, "lng": -118.595000},
      {"lat": 34.124000, "lng": -118.590000},
      {"lat": 34.121500, "lng": -118.593000},
      {"lat": 34.122500, "lng": -118.598000}
    ]
  },
  {
    "name": "Calabasas Heatwave Fire",
    "severity": "High",
    "polygon": [
      {"lat": 34.136000, "lng": -118.660000},
      {"lat": 34.138500, "lng": -118.656000},
      {"lat": 34.135500, "lng": -118.652000},
      {"lat": 34.132800, "lng": -118.655000},
      {"lat": 34.134000, "lng": -118.659000}
    ]
  },
  {
    "name": "Chatsworth Peak Burn",
    "severity": "Moderate",
    "polygon": [
      {"lat": 34.268000, "lng": -118.611000},
      {"lat": 34.269500, "lng": -118.607000},
      {"lat": 34.266000, "lng": -118.603000},
      {"lat": 34.263500, "lng": -118.606500},
      {"lat": 34.265000, "lng": -118.610000}
    ]
  },
  {
    "name": "Porter Ranch Flashfire",
    "severity": "Critical",
    "polygon": [
      {"lat": 34.288000, "lng": -118.552000},
      {"lat": 34.289500, "lng": -118.547000},
      {"lat": 34.286000, "lng": -118.544000},
      {"lat": 34.283500, "lng": -118.548000},
      {"lat": 34.285000, "lng": -118.551000}
    ]
  },
  {
    "name": "San Gabriel Brushfire",
    "severity": "High",
    "polygon": [
      {"lat": 34.145000, "lng": -118.000000},
      {"lat": 34.147500, "lng": -117.996000},
      {"lat": 34.144000, "lng": -117.992000},
      {"lat": 34.140500, "lng": -117.996500},
      {"lat": 34.142000, "lng": -118.000500}
    ]
  },
  {
    "name": "Silver Lake Burnzone",
    "severity": "Low",
    "polygon": [
      {"lat": 34.091000, "lng": -118.280000},
      {"lat": 34.092500, "lng": -118.276000},
      {"lat": 34.090000, "lng": -118.273000},
      {"lat": 34.088000, "lng": -118.276500},
      {"lat": 34.089500, "lng": -118.279000}
    ]
  },
  {
    "name": "Eagle Rock Fire Patch",
    "severity": "Moderate",
    "polygon": [
      {"lat": 34.140000, "lng": -118.214000},
      {"lat": 34.141500, "lng": -118.210000},
      {"lat": 34.139000, "lng": -118.207000},
      {"lat": 34.137000, "lng": -118.210500},
      {"lat": 34.138500, "lng": -118.213000}
    ]
  },
  {
    "name": "Tujunga Canyon Wildfire",
    "severity": "Critical",
    "polygon": [
      {"lat": 34.269000, "lng": -118.270000},
      {"lat": 34.270500, "lng": -118.265000},
      {"lat": 34.268000, "lng": -118.261000},
      {"lat": 34.265500, "lng": -118.265000},
      {"lat": 34.267000, "lng": -118.269000}
    ]
  }
];
