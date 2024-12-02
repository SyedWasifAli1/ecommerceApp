import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[300],
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Sameera Perera',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'sameera@gmail.com',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildListTile(
                  context,
                  icon: Icons.person_outline,
                  title: 'Profile',
                  onTap: () {},
                ),
                _buildListTile(
                  context,
                  icon: Icons.shopping_bag_outlined,
                  title: 'Orders',
                  onTap: () {},
                ),
                _buildListTile(
                  context,
                  icon: Icons.location_on_outlined,
                  title: 'Delivery Info',
                  onTap: () {},
                ),
                _buildListTile(
                  context,
                  icon: Icons.location_on_outlined,
                  title: 'Delivery Info',
                  onTap: () {},
                ),
                _buildListTile(
                  context,
                  icon: Icons.location_on_outlined,
                  title: 'Delivery Info',
                  onTap: () {},
                ),
                _buildListTile(
                  context,
                  icon: Icons.location_on_outlined,
                  title: 'Delivery Info',
                  onTap: () {},
                ),
                _buildListTile(
                  context,
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () {},
                ),
                _buildListTile(
                  context,
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  onTap: () {},
                ),
                _buildListTile(
                  context,
                  icon: Icons.info_outline,
                  title: 'About',
                  onTap: () {},
                ),
                _buildListTile(
                  context,
                  icon: Icons.logout,
                  title: 'Sign Out',
                  onTap: () {
                    // Add sign out logic here
                  },
                  isSignOut: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap,
      bool isSignOut = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        tileColor: Colors.grey[200],
        leading: Icon(
          icon,
          color: isSignOut ? Colors.red : Colors.black,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: isSignOut ? Colors.red : Colors.black,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}
