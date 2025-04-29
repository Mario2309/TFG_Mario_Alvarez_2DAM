import 'package:flutter/material.dart';
import 'package:myapp/home_page.dart';
import 'package:myapp/search_page.dart';
import 'package:myapp/profile_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('NexusERP')),
        backgroundColor: Colors.blue.shade700, // Consistent app bar color
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue.shade700, // Consistent selected color
        unselectedItemColor: Colors.grey.shade600,
        onTap: _onItemTapped,
        backgroundColor: Colors.white, // Optional: Set background color
        elevation: 8, // Add a subtle shadow
      ),
    );
  }
}