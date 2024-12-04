import 'package:ecommerce/screen/home/admin_dashboard.dart';
import 'package:ecommerce/screen/home/widgets/buttom_navigator_bar.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'categories_page.dart';
import 'cart_page.dart';
import 'profile_page.dart';

class HomeScreen extends StatefulWidget {
  final String role; // Role passed from the login

  HomeScreen({required this.role}); // Constructor to accept role

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // List of customer pages
  final List<Widget> _customerPages = [
    HomePage(),
    CategoriesPage(),
    CartPage(),
    ProfilePage(),
  ];

  // List of admin pages
  final List<Widget> _adminPages = [
    AdminDashboardPage(),
    CategoriesPage(), // Admin can access categories too
    CartPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.role == 'admin'
            ? Text('Admin Dashboard')
            : Text('Ecommerce App'),
      ),
      body: widget.role == 'admin'
          ? _adminPages[_currentIndex] // Show admin pages
          : _customerPages[_currentIndex], // Show customer pages
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        isAdmin: widget.role == 'admin', // Pass role to BottomNavigation
      ),
    );
  }
}
