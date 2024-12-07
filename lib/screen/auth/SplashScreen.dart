import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Check if user is logged in
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');

    if (uid != null) {
      // User is logged in, fetch role and navigate accordingly
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('customers')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        String role = userDoc['role'];

        // Navigate based on role
        if (role == 'admin') {
          Navigator.pushReplacementNamed(context, '/homeadmin');
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } else {
      // If no user is logged in, navigate to Login screen
      // Navigator.pushReplacementNamed(context, '/login');
      GoRouter.of(context).go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            CircularProgressIndicator(), // Show loading indicator while checking
      ),
    );
  }
}
