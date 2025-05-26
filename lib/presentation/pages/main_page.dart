import 'package:flutter/material.dart';
import 'package:nexuserp/presentation/pages/home_page.dart';
import 'package:nexuserp/presentation/pages/search_page.dart';
import 'package:nexuserp/presentation/pages/profile_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [HomePage(), SearchPage(), ProfilePage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'NexusERP',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.blue.shade700, // Consistent app bar color
        elevation: 4, // Slight shadow for the app bar
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Icono de "Inicio" relleno
            activeIcon: Icon(
              Icons.home_outlined,
            ), // Icono de "Inicio" sin relleno cuando está inactivo
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_module), // Icono de "Módulos" relleno
            activeIcon: Icon(
              Icons.view_module_outlined,
            ), // Icono de "Módulos" sin relleno cuando está inactivo
            label: 'Módulos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Icono de "Perfil" relleno
            activeIcon: Icon(
              Icons.person_outline,
            ), // Icono de "Perfil" sin relleno cuando está inactivo
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue.shade700, // Consistent selected color
        unselectedItemColor: Colors.grey.shade600,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        elevation: 8, // Add a subtle shadow
      ),
    );
  }
}
