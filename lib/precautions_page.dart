import 'package:flutter/material.dart';

class PrecautionsPage extends StatelessWidget {
  final List<Map<String, String>> precautions = [
    {
      'title': 'Fire Starting',
      'description': 'Avoid open flames and use fire-resistant clothing.',
      'image': 'assets/fire_starting.png',
    },
    {
      'title': 'Evacuation',
      'description': 'Follow the safest route and avoid panicking.',
      'image': 'assets/evacuation.png',
    },
    {
      'title': 'Smoke Inhalation',
      'description': 'Stay indoors, close windows, and use masks.',
      'image': 'assets/smoke_inhalation.png',
    },
    {
      'title': 'Burns',
      'description': 'Cover with clean cloths.',
      'image': 'assets/burns.png',
    },
    {
      'title': 'First Aid',
      'description': 'Know basic first aid for burns, cuts, and fractures.',
      'image': 'assets/first_aid.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
      ),
      itemCount: precautions.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(10),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  precautions[index]['image']!,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.broken_image, size: 80, color: Colors.grey);
                  },
                ),

                SizedBox(height: 10),
                Text(
                  precautions[index]['title']!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    precautions[index]['description']!,
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
