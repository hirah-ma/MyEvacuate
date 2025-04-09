import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<void> uploadDummyFireZones() async {
  final dummyZones = [
    {
      "name": "Red Ember Zone",
      "coordinates": [
        {"lat": 17.5195, "lng": 78.3685},
        {"lat": 17.5198, "lng": 78.3681},
        {"lat": 17.5193, "lng": 78.3676},
        {"lat": 17.5189, "lng": 78.3680},
      ],
    },
    {
      "name": "Ashfall Ridge",
      "coordinates": [
        {"lat": 17.5202, "lng": 78.3690},
        {"lat": 17.5205, "lng": 78.3685},
        {"lat": 17.5201, "lng": 78.3680},
        {"lat": 17.5198, "lng": 78.3686},
      ],
    },
    {
      "name": "Crimson Basin",
      "coordinates": [
        {"lat": 17.5185, "lng": 78.3672},
        {"lat": 17.5189, "lng": 78.3668},
        {"lat": 17.5183, "lng": 78.3665},
        {"lat": 17.5180, "lng": 78.3670},
      ],
    },
    {
      "name": "Blaze Hollow",
      "coordinates": [
        {"lat": 17.5210, "lng": 78.3675},
        {"lat": 17.5212, "lng": 78.3671},
        {"lat": 17.5208, "lng": 78.3669},
        {"lat": 17.5206, "lng": 78.3673},
      ],
    },
    {
      "name": "Flare Hill",
      "coordinates": [
        {"lat": 17.5205, "lng": 78.3655},
        {"lat": 17.5209, "lng": 78.3651},
        {"lat": 17.5203, "lng": 78.3648},
        {"lat": 17.5199, "lng": 78.3653},
      ],
    },
    {
      "name": "Scorched Pines",
      "coordinates": [
        {"lat": 17.5190, "lng": 78.3702},
        {"lat": 17.5194, "lng": 78.3698},
        {"lat": 17.5188, "lng": 78.3695},
        {"lat": 17.5185, "lng": 78.3700},
      ],
    },
    {
      "name": "Inferno Valley",
      "coordinates": [
        {"lat": 17.5175, "lng": 78.3685},
        {"lat": 17.5179, "lng": 78.3680},
        {"lat": 17.5173, "lng": 78.3676},
        {"lat": 17.5169, "lng": 78.3681},
      ],
    },
    {
      "name": "Smoke Drift Plains",
      "coordinates": [
        {"lat": 17.5220, "lng": 78.3685},
        {"lat": 17.5224, "lng": 78.3680},
        {"lat": 17.5218, "lng": 78.3676},
        {"lat": 17.5214, "lng": 78.3681},
      ],
    },
    {
      "name": "Wildflare Cross",
      "coordinates": [
        {"lat": 17.5182, "lng": 78.3662},
        {"lat": 17.5186, "lng": 78.3658},
        {"lat": 17.5180, "lng": 78.3655},
        {"lat": 17.5176, "lng": 78.3660},
      ],
    },
    {
      "name": "Charred Grove",
      "coordinates": [
        {"lat": 17.5208, "lng": 78.3705},
        {"lat": 17.5212, "lng": 78.3701},
        {"lat": 17.5206, "lng": 78.3698},
        {"lat": 17.5202, "lng": 78.3703},
      ],
    },
    {
      "name": "Burnt Trail",
      "coordinates": [
        {"lat": 17.5215, "lng": 78.3660},
        {"lat": 17.5219, "lng": 78.3656},
        {"lat": 17.5213, "lng": 78.3653},
        {"lat": 17.5209, "lng": 78.3658},
      ],
    },
    {
      "name": "Lava Pines",
      "coordinates": [
        {"lat": 17.5195, "lng": 78.3650},
        {"lat": 17.5199, "lng": 78.3646},
        {"lat": 17.5193, "lng": 78.3643},
        {"lat": 17.5189, "lng": 78.3648},
      ],
    },
    {
      "name": "Firestorm Crest",
      "coordinates": [
        {"lat": 17.5170, "lng": 78.3670},
        {"lat": 17.5174, "lng": 78.3666},
        {"lat": 17.5168, "lng": 78.3663},
        {"lat": 17.5164, "lng": 78.3668},
      ],
    },
    {
      "name": "Ashen Steps",
      "coordinates": [
        {"lat": 17.5225, "lng": 78.3695},
        {"lat": 17.5229, "lng": 78.3691},
        {"lat": 17.5223, "lng": 78.3688},
        {"lat": 17.5219, "lng": 78.3693},
      ],
    },
    {
      "name": "Torchlight Fields",
      "coordinates": [
        {"lat": 17.5178, "lng": 78.3708},
        {"lat": 17.5182, "lng": 78.3704},
        {"lat": 17.5176, "lng": 78.3701},
        {"lat": 17.5172, "lng": 78.3706},
      ],
    },
  ];

  final firestore = FirebaseFirestore.instance;

  for (var zone in dummyZones) {
    await firestore.collection('fire_zones').add(zone);
  }

  print("🔥 Dummy fire zones uploaded.");
}
