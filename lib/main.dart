import 'package:flutter/material.dart';
import 'precautions_page.dart';
import 'helpline_page.dart';
import 'services_page.dart';
import 'map_routes_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'sign_in_page.dart';
import 'locationhelper/location_firestore_service.dart';
import 'locationhelper/firezones.dart';
//import 'firezones/upload_kml_to_firestore.dart';

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
          bodyLarge: TextStyle(fontSize: 18.0),
          bodyMedium: TextStyle(fontSize: 16.0),
          titleLarge: TextStyle(fontSize: 22.0),
          labelLarge: TextStyle(fontSize: 18.0),
        ),
        appBarTheme: const AppBarTheme(
          toolbarHeight: 80,
          iconTheme: IconThemeData(size: 30),
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
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasData) {
          return HomePage();
        } else {
          return SignInPage();
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
  bool _zonesUploaded = false;

  final List<Widget> _pages = [
    MapRoutesPage(),
    ServicesPage(),
    PrecautionsPage(),
    HelplinePage(),
  ];

  @override
  void initState() {
    super.initState();

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
      body: _pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        iconSize: 30,
        selectedFontSize: 16,
        unselectedFontSize: 14,
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