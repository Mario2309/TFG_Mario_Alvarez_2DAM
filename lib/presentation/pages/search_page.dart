import 'package:flutter/material.dart';
import 'package:nexuserp/features/employee/presentation/pages/employees_page.dart';
import 'package:nexuserp/features/product/presentation/pages/products_page.dart';
import 'package:nexuserp/features/supliers/presentation/pages/supplier_page.dart';
import 'package:nexuserp/features/inventory/presentation/pages/inventory_details_page.dart';
import 'package:nexuserp/features/vacation/presentation/pages/vacations_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late List<_SearchOption> _filteredOptions;
  late final List<_SearchOption> _allOptions;

  @override
  void initState() {
    super.initState();
    _allOptions = [
      _SearchOption("Products", Icons.shopping_bag_outlined, ProductsPage()),
      _SearchOption("Employees", Icons.people_alt_outlined, EmployeesPage()),
      _SearchOption(
        "Suppliers",
        Icons.local_shipping_outlined,
        SuppliersPage(),
      ),
      _SearchOption(
        "Inventory",
        Icons.inventory_2_outlined,
        InventoryDetailsPage(),
      ),
      _SearchOption("Vacaciones", Icons.beach_access_outlined, VacationsPage()),
    ];
    _filteredOptions = List.from(_allOptions);

    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        _filteredOptions =
            _allOptions
                .where((option) => option.title.toLowerCase().contains(query))
                .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          final crossAxisCount = isMobile ? 2 : 3;

          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 1000),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildSearchBar(),
                    const SizedBox(height: 20),
                    Expanded(
                      child:
                          _filteredOptions.isEmpty
                              ? Center(
                                child: Text(
                                  'No se encontraron resultados.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              )
                              : GridView.builder(
                                itemCount: _filteredOptions.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 20,
                                      childAspectRatio: 1,
                                    ),
                                itemBuilder: (context, index) {
                                  final option = _filteredOptions[index];
                                  return _buildAnimatedOption(
                                    context,
                                    option,
                                    index,
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Buscar...',
        prefixIcon: Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildAnimatedOption(
    BuildContext context,
    _SearchOption option,
    int index,
  ) {
    final animationDuration = Duration(milliseconds: 300 + (index * 100));

    return TweenAnimationBuilder(
      duration: animationDuration,
      curve: Curves.easeOut,
      tween: Tween<Offset>(begin: Offset(0, 0.2), end: Offset.zero),
      builder: (context, offset, child) {
        return AnimatedOpacity(
          opacity: 1.0,
          duration: animationDuration,
          child: Transform.translate(offset: offset * 100, child: child),
        );
      },
      child: _buildModernOption(
        context,
        option.title,
        option.icon,
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => option.page),
        ),
      ),
    );
  }

  Widget _buildModernOption(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: Colors.blue.withOpacity(0.2),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 50, color: Colors.blue.shade700),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchOption {
  final String title;
  final IconData icon;
  final Widget page;

  _SearchOption(this.title, this.icon, this.page);
}
