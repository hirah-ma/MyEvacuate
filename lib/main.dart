import 'package:flutter/material.dart';
import 'precautions_page.dart';
import 'helpline_page.dart';
import 'services_page.dart';
import 'map_routes_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'sign_in_page.dart'; // import your SignInPage
import 'locationhelper/location_firestore_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: AuthWrapper(),
      routes: {
        '/home': (context) => HomePage(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // listens to login/logout
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasData) {
          return HomePage(); // Logged in ✅
        } else {
          return SignInPage(); // Not logged in 🔐
        }
      },
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
  void initState() {
    super.initState();

    // Delayed location fetch after ensuring FirebaseAuth is ready
    Future.delayed(Duration(milliseconds: 300), () async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print('👤 Logged in user: ${user.email}');
        await LocationFirestoreService().storeUserLocation();
      } else {
        print('🚫 No user in delayed initState');
      }
    });
  }

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
