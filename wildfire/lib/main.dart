import 'package:flutter/material.dart';
import 'precautions_page.dart';
import 'helpline_page.dart';
import 'services_page.dart';
import 'map_routes_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wildfire Safety App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18.0), // Default body text (large)
          bodyMedium: TextStyle(fontSize: 16.0), // Secondary text (medium)
          titleLarge: TextStyle(fontSize: 22.0), // AppBar title size
          labelLarge: TextStyle(fontSize: 18.0), // Button text size
        ),
        appBarTheme: const AppBarTheme(
          toolbarHeight: 80, // Increase AppBar height
          iconTheme: IconThemeData(
            size: 30, // Increase icon size inside the AppBar
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // Pages for each section
  final List<Widget> _pages = [
    MapRoutesPage(), // Map Routes Page
    ServicesPage(), // Services Nearby Page
    PrecautionsPage(), // Precautions Page
    HelplinePage(), // Helpline Page
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wildfire Safety'),
        centerTitle: true,
      ),
      body: _pages[_currentIndex], // Show the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Switch to the selected tab
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        iconSize: 30, // Increased size of the icons in BottomNavigationBar
        selectedFontSize: 16, // Increased size of the label text
        unselectedFontSize: 14, // Decreased size of the unselected label text
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map Routes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: 'Services Nearby',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'Precautions & News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            label: 'Entries & Helpline',
          ),
        ],
      ),
    );
  }
}
