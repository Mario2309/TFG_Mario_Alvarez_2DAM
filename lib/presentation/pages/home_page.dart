import 'package:flutter/material.dart';
import 'package:nexuserp/features/employee/data/models/employee_model.dart';
import 'package:nexuserp/features/employee/domain/entities/employee.dart';
import 'package:nexuserp/features/employee/presentation/pages/edit_employee_page.dart';
import 'package:nexuserp/features/product/domain/entities/product.dart';
import 'package:nexuserp/features/product/presentation/pages/edit_product.dart';
import 'package:nexuserp/features/supliers/domain/entities/supplier.dart';
import 'package:nexuserp/features/employee/data/datasources/employee_service.dart';
import 'package:nexuserp/features/product/data/datasources/product_service.dart';
import 'package:nexuserp/features/product/data/models/product_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Employee> _employees = [];
  List<Product> _products = [];
  List<Supplier> _suppliers = [];
  final EmployeeService _employeeService = EmployeeService();
  final ProductService _productService = ProductService();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final employeeModels = await _employeeService.fetchEmployees();
    final productModels = await _productService.fetchProducts();

    setState(() {
      _employees =
          employeeModels
              .map(
                (model) => Employee(
                  id: model.id,
                  nombreCompleto: model.nombreCompleto,
                  nacimiento: model.nacimiento,
                  correoElectronico: model.correoElectronico,
                  numeroTelefono: model.numeroTelefono,
                  dni: model.dni,
                ),
              )
              .toList();

      _products =
          productModels
              .map(
                (model) => Product(
                  id: model.id,
                  nombre: model.nombre,
                  tipo: model.tipo,
                  precio: model.precio,
                  cantidad: model.cantidad,
                  descripcion: model.descripcion,
                  proveedorId: model.proveedorId,
                ),
              )
              .toList();

      _suppliers = [
        Supplier(
          id: 1,
          name: 'Tech Solutions Inc.',
          taxId: 'TS12345',
          contactPerson: 'John Smith',
          phone: '555-987-6543',
          email: 'john.smith@techsolutions.com',
          address: '123 Main St',
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Employees'),
            _employees.isEmpty
                ? _buildEmptyState('No employees data available.')
                : _buildEmployeeList(),
            const SizedBox(height: 24.0),
            _buildSectionTitle('Products'),
            _products.isEmpty
                ? _buildEmptyState('No products data available.')
                : _buildProductList(),
            const SizedBox(height: 24.0),
            _buildSectionTitle('Suppliers'),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0, bottom: 16.0),
          child: FloatingActionButton(
            onPressed: _loadInitialData,
            tooltip: 'Recargar página',
            backgroundColor: Colors.blue.shade700,
            child: const Icon(Icons.refresh),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Colors.blue.shade700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(message, style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  Widget _buildEmployeeList() {
    return SizedBox(
      height: 190,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _employees.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final employee = _employees[index];
          return _buildEmployeeCard(employee);
        },
      ),
    );
  }

  Widget _buildEmployeeCard(Employee employee) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      elevation: 3,
      color: Colors.blue[50],
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => EditEmployeePage(
                    employee: EmployeeModel(
                      id: employee.id,
                      nombreCompleto: employee.nombreCompleto,
                      nacimiento: employee.nacimiento,
                      correoElectronico: employee.correoElectronico,
                      numeroTelefono: employee.numeroTelefono,
                      dni: employee.dni,
                    ),
                    employeeService: _employeeService,
                  ),
            ),
          );
          if (result == true) {
            _loadInitialData();
          }
        },
        child: Container(
          width: 180,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.person, color: Colors.blue.shade700, size: 32),
              const SizedBox(height: 8),
              Text(
                employee.nombreCompleto,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              _buildInfoLine(Icons.email, employee.correoElectronico ?? 'N/A'),
              if (employee.numeroTelefono?.isNotEmpty ?? false)
                _buildInfoLine(Icons.phone, employee.numeroTelefono!),
              if (employee.dni?.isNotEmpty ?? false)
                _buildInfoLine(Icons.badge, 'DNI: ${employee.dni!}'),
              if (employee.nacimiento != null)
                _buildInfoLine(
                  Icons.cake,
                  'Nacimiento: ${employee.nacimiento!.day}/${employee.nacimiento!.month}/${employee.nacimiento!.year}',
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductList() {
    return SizedBox(
      height: 190,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final product = _products[index];
          return _buildProductCard(product);
        },
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      elevation: 3,
      color: Colors.green[50],
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => EditProductPage(
                    product: ProductModel(
                      id: product.id,
                      nombre: product.nombre,
                      tipo: product.tipo,
                      precio: product.precio,
                      cantidad: product.cantidad,
                      descripcion: product.descripcion,
                      proveedorId: product.proveedorId,
                    ),
                    productService: _productService,
                  ),
            ),
          );
          if (result == true) {
            _loadInitialData();
          }
        },
        child: Container(
          width: 180,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.shopping_bag, color: Colors.green.shade700, size: 32),
              const SizedBox(height: 8),
              Text(
                product.nombre,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              _buildInfoLine(Icons.category, 'Tipo: ${product.tipo}'),
              _buildInfoLine(
                Icons.monetization_on,
                'Precio: \$${product.precio.toStringAsFixed(2)}',
              ),
              _buildInfoLine(Icons.inventory, 'Stock: ${product.cantidad}'),
              if (product.descripcion != null &&
                  product.descripcion!.isNotEmpty)
                _buildInfoLine(Icons.info, product.descripcion!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoLine(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.blue.shade700),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
