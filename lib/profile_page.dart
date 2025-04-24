import 'package:flutter/material.dart';

class UserData {
  final String name;
  final String email;
  final String description;
  final String image;

  UserData({
    this.name = 'User Name',
    this.email = 'user@email.com',
    this.description = 'User description',
    this.image = 'assets/default_profile.png',
  });
}

class ProfilePage extends StatelessWidget {
  final UserData userData = UserData();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage(userData.image),
            backgroundColor: Colors.grey[200],
          ),
          const SizedBox(height: 20),
          Text(
            userData.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            userData.email,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Text(
            userData.description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}