import 'package:flutter/material.dart';
import 'package:myapp/add_product.dart';
import 'package:myapp/models/employee.dart';
import 'package:myapp/models/product.dart';
import 'package:myapp/services/employee_service.dart';
import 'package:myapp/services/inventory_service.dart';
import 'package:myapp/add_employee.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

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
        title: const Text('Bottom Navigation Bar Example'),
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProductScreen()),
                );
              },
              child: const Icon(Icons.add_box_outlined),
              heroTag: "addProduct", // Unique tag for the first button
            ),
            SizedBox(width: 16),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddEmployeeScreen()),
                );
              },
              child: const Icon(Icons.person_add_alt_1),
              heroTag: "addEmployee", // Unique tag for the second button
            ),
          ]),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final InventoryService _inventoryService = InventoryService();
  final EmployeeService _employeeService = EmployeeService();

  @override
  Widget build(BuildContext context) {
    List<Product> products = _inventoryService.getAllProducts();
    List<Employee> employees = _employeeService.getAllEmployees();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Products",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
          ),
          products.isEmpty
              ? Center(child: Text("No products data"))
              : SizedBox(
                height: 200, // Set a fixed height for the list
                child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(products[index].name),
                      );
                    },
                  ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Employees",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
              ),
              employees.isEmpty
                  ? Center(child: Text("No employees data"))
                  : SizedBox(
                    height: 200, // Set a fixed height for the list
                    child: ListView.builder(
                        itemCount: employees.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(employees[index].name),
                            subtitle: Text(employees[index].position),
                          );
                        },
                      ),
                  ),
        ],
      ),
    );
    
  }
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Search Page'),
    );
  }
}

class UserData {
  final String name;
  final String email;
  final String description;
  final String image;

  UserData({this.name = 'User Name', this.email = 'user@email.com', this.description = 'User description', this.image = 'assets/default_profile.jpg'});
}

class ProfilePage extends StatelessWidget {
  final UserData userData = UserData();
  @override
  Widget build(BuildContext context) {
    return  Padding(
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