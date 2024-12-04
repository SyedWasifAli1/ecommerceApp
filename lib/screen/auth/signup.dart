import 'package:ecommerce/screen/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> signUpUser(String email, String password) async {
    try {
      // Create user
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Account creation is successful
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Sign up successful!')));

      // Add user to the database and save the session
      await addUserToDatabase(userCredential.user!.uid, email);
      await saveUserSession(userCredential.user!.uid);

      // Navigate to HomePage
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign up failed: ${e.toString()}')),
      );
    }
  }

  Future<void> addUserToDatabase(String userId, String email) async {
    try {
      String role = email.contains('@admin.com') ? 'admin' : 'customer';
      await FirebaseFirestore.instance.collection('customers').doc(userId).set({
        'id': userId,
        'email': email,
        'role': role,
        'billingAddress': '',
        'country': '',
        'defaultShippingAddress': '',
        'fullName': '',
        'phone': '',
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save data: ${e.toString()}')),
      );
    }
  }

  Future<void> saveUserSession(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your email' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter your password'
                    : null,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    signUpUser(
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                    );
                  }
                },
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Home Page')),
//       body: Center(
//         child: Text('Welcome to the Home Page!'),
//       ),
//     );
//   }
// }
