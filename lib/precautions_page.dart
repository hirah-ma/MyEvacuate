import 'package:flutter/material.dart';
import 'chat/chatscreen.dart'; // Ensure this points to CommunityChatPage

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
    {
      'title': 'Community Chat',
      'description': 'Chat with nearby users',
      'image': 'assets/community_chat.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
      ),
      itemCount: precautions.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(10),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: () {
              if (precautions[index]['title'] == 'Community Chat') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommunityChatPage(areaId: 'hyd_500090'),
                  ),
                );
              }
            },
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
                    return const Icon(Icons.broken_image, size: 80, color: Colors.grey);
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  precautions[index]['title']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    precautions[index]['description']!,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
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
