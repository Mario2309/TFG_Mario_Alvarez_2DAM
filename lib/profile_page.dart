import 'package:flutter/material.dart';

class UserData {
  final String name;
  final String email;
  final String description;
  final String image;

  UserData({
    this.name = 'User Name',
    this.email = 'user@email.com',
    this.description = 'User description goes here.',
    this.image = 'assets/assets/default_profile.png',
  });
}

class ProfilePage extends StatelessWidget {
  final UserData userData = UserData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue.shade700, // Consistent app bar color
      ),
      body: SingleChildScrollView(
        // Added SingleChildScrollView for content that might overflow
        padding: const EdgeInsets.all(
          24.0,
        ), // Increased padding for better spacing
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 70, // Slightly larger avatar
              backgroundImage: AssetImage(userData.image),
              backgroundColor: Colors.grey[300], // Slightly darker background
            ),
            const SizedBox(height: 24), // Increased spacing
            Text(
              userData.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 21, 101, 191),
              ), // More prominent name
            ),
            const SizedBox(height: 12), // Adjusted spacing
            Text(
              userData.email,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ), // Improved email styling
            ),
            const SizedBox(height: 32), // Increased spacing
            const Divider(), // Added a divider for visual separation
            const SizedBox(height: 16),
            Text(
              'About Me',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ), // Section title
            ),
            const SizedBox(height: 12),
            Text(
              userData.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                height: 1.4,
              ), // Added line height for better readability
            ),
          ],
        ),
      ),
    );
  }
}
