import 'package:flutter/material.dart';
import 'package:myapp/home_page.dart';
import 'package:myapp/search_page.dart';
import 'package:myapp/profile_page.dart';
import 'package:myapp/add_product_screen.dart';
import 'package:myapp/add_employee_screen.dart';

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
        title: const Text('Main Menu'),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70.0), // Adjust padding above bottom navigation
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "addProduct",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProductScreen()),
                );
              },
              backgroundColor: Colors.green.shade400, // Distinct color for add product
              child: const Icon(Icons.add_box_outlined, color: Colors.white),
              elevation: 4,
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              heroTag: "addEmployee",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddEmployeeScreen()),
                );
              },
              backgroundColor: Colors.orange.shade400, // Distinct color for add employee
              child: const Icon(Icons.person_add_alt_1, color: Colors.white),
              elevation: 4,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Ensure FABs are positioned correctly
    );
  }
}