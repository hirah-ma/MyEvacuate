import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'SignUpPage.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _error = '';

  Future<void> _signIn() async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());

      // Navigate to HomePage
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      setState(() {
        _error = 'Login failed: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: _passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _signIn, child: Text('Sign In')),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: Text("Don't have an account? Sign up"),
            ),

            if (_error.isNotEmpty) Text(_error, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
