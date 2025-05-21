import 'package:flutter/material.dart';
import 'dart:math';

import 'package:nexuserp/features/employee/data/models/employee_model.dart';
import 'package:nexuserp/features/employee/data/repositories/employee_repository_impl.dart';
import 'package:nexuserp/features/employee/domain/entities/employee.dart';
import 'package:nexuserp/features/employee/presentation/pages/employee_options_page.dart';
import 'package:nexuserp/features/product/domain/entities/product.dart';
import 'package:nexuserp/features/product/presentation/pages/edit_product.dart';
import 'package:nexuserp/features/supliers/domain/entities/supplier.dart';
import 'package:nexuserp/features/employee/data/datasources/employee_service.dart';
import 'package:nexuserp/features/product/data/datasources/product_service.dart';
import 'package:nexuserp/features/product/data/models/product_model.dart';
import '../../features/supliers/data/datasources/suppliers_service.dart';
//import 'package:charts_flutter/flutter.dart' as charts; // Importar charts_flutter - Eliminado

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Employee> _employees = [];
  List<Product> _products = [];
  List<Supplier> _suppliers = [];

  final EmployeeService _employeeService = EmployeeService();
  final ProductService _productService = ProductService();
  final SupplierService _supplierService = SupplierService();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final employeeModels = await _employeeService.fetchEmployees();
      final productModels = await _productService.fetchProducts();
      final supplierModels = await _supplierService.fetchSuppliers();

      if (!mounted) return;

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
                    sueldo: model.sueldo,
                    cargo: model.cargo,
                    fechaContratacion: model.fechaContratacion,
                    activo: model.activo,
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

        _suppliers =
            supplierModels
                .map(
                  (model) => Supplier(
                    id: model.id,
                    nombre: model.nombre,
                    nifCif: model.nifCif,
                    personaContacto: model.personaContacto,
                    telefono: model.telefono,
                    correoElectronico: model.correoElectronico,
                    direccion: model.direccion,
                  ),
                )
                .toList();
      });
    } catch (e) {
      // Log the error with más detalles (opcional, para debugging)
      debugPrint('Error loading data: $e');
      // Mostrar un mensaje de error amigable para el usuario (opcional)
      if (mounted) {
        // Check if the widget is still in the tree
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load data. Please check your connection.'),
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: _loadInitialData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Gráfico de Empleados'),
              _employees.isEmpty
                  ? _buildEmptyState('No hay datos de empleados disponibles.')
                  : _buildEmployeeChart(
                    context,
                  ), // Muestra el gráfico de empleados
              const SizedBox(height: 24.0),
              _buildSectionTitle('Gráfico de Productos'),
              _products.isEmpty
                  ? _buildEmptyState('No hay datos de productos disponibles.')
                  : _buildProductChart(
                    context,
                  ), // Muestra el gráfico de productos
              const SizedBox(height: 24.0),
              _buildSectionTitle('Gráfico de Proveedores'),
              _suppliers.isEmpty
                  ? _buildEmptyState('No hay datos de proveedores disponibles.')
                  : _buildSupplierChart(
                    context,
                  ), // Muestra el gráfico de proveedores
              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0, bottom: 16.0),
          child: FloatingActionButton(
            onPressed: _loadInitialData,
            tooltip: 'Recargar página',
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.refresh, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          message,
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ),
    );
  }

  // Widget para mostrar el gráfico de empleados
  Widget _buildEmployeeChart(BuildContext context) {
    // Preparar los datos para el gráfico
    final List<double> employeeSalaries =
        _employees.map((employee) => employee.sueldo).toList();
    final double maxSalary =
        employeeSalaries.isNotEmpty ? employeeSalaries.reduce(max) : 0;
    final int numberOfEmployees = _employees.length;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 200, // Altura del gráfico
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), // Más redondeado
          color: Colors.white,
          boxShadow: [
            // Sombra para dar profundidad
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2), // Desplazamiento de la sombra
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Salarios de Empleados',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ), // Aumentar tamaño título
              ),
              const SizedBox(height: 12),
              if (numberOfEmployees > 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Empleados: $numberOfEmployees',
                      style: const TextStyle(fontSize: 14),
                    ), // Estilo para el texto
                    Text(
                      'Salario Máximo: \$${maxSalary.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                )
              else
                const Text(
                  'No hay empleados registrados.',
                  style: const TextStyle(fontSize: 14),
                ),
              const SizedBox(height: 16),
              Expanded(
                child:
                // Aquí se muestra el gráfico de líneas
                CustomPaint(
                  painter: EmployeeChartPainter(
                    employeeSalaries,
                    isLineChart: true,
                  ),
                  size: Size(MediaQuery.of(context).size.width, 200),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para mostrar el gráfico de productos
  Widget _buildProductChart(BuildContext context) {
    // Preparar los datos para el gráfico
    final List<double> productQuantities =
        _products.map((product) => product.cantidad.toDouble()).toList();
    final double maxQuantity =
        productQuantities.isNotEmpty ? productQuantities.reduce(max) : 0;
    final int numberOfProducts = _products.length;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), // Más redondeado
          color: Colors.white,
          boxShadow: [
            // Sombra para dar profundidad
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2), // Desplazamiento de la sombra
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cantidad de Productos',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ), // Aumentar tamaño título
              ),
              const SizedBox(height: 12),
              if (numberOfProducts > 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Productos: $numberOfProducts',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Máxima Cantidad: ${maxQuantity.toInt()}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                )
              else
                const Text(
                  'No hay productos registrados.',
                  style: const TextStyle(fontSize: 14),
                ),
              const SizedBox(height: 16),
              Expanded(
                child:
                // Aquí se muestra el gráfico de líneas
                CustomPaint(
                  painter: ProductChartPainter(
                    productQuantities,
                    isLineChart: true,
                  ),
                  size: Size(MediaQuery.of(context).size.width, 200),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para mostrar el gráfico de proveedores
  Widget _buildSupplierChart(BuildContext context) {
    final int numberOfSuppliers = _suppliers.length;
    final List<String> supplierNames =
        _suppliers.map((supplier) => supplier.nombre).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), // Más redondeado
          color: Colors.white,
          boxShadow: [
            // Sombra para dar profundidad
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2), // Desplazamiento de la sombra
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Número de Proveedores',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ), // Aumentar tamaño título
              ),
              const SizedBox(height: 12),
              Text(
                'Total Proveedores: $numberOfSuppliers',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Expanded(
                child:
                // Aquí se muestra el gráfico de líneas
                CustomPaint(
                  painter: SupplierChartPainter(
                    supplierNames,
                    isLineChart: true,
                  ),
                  size: Size(MediaQuery.of(context).size.width, 200),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoLine(
    IconData icon,
    String text, {
    Color textColor = Colors.grey,
    Color iconColor = Colors.blue,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: textColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// Clase para dibujar el gráfico de líneas de salarios de empleados
class EmployeeChartPainter extends CustomPainter {
  final List<double> employeeSalaries;
  final bool isLineChart;

  EmployeeChartPainter(this.employeeSalaries, {this.isLineChart = false});

  @override
  void paint(Canvas canvas, Size size) {
    if (employeeSalaries.isEmpty) {
      return;
    }

    double maxSalary = employeeSalaries.reduce(max);
    double availableHeight = size.height - 30; // Espacio para etiquetas
    double xSpace = size.width / (employeeSalaries.length - 1);

    List<Offset> points = [];
    for (int i = 0; i < employeeSalaries.length; i++) {
      double x = i * xSpace;
      double y =
          size.height -
          (employeeSalaries[i] / maxSalary) * availableHeight -
          20;
      points.add(Offset(x, y));
    }

    // Dibujar la línea
    Paint linePaint =
        Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.stroke
          ..strokeWidth =
              3 // Línea más gruesa
          ..strokeCap = StrokeCap.round; // Línea redondeada

    if (isLineChart) {
      Path path = Path();
      path.moveTo(points[0].dx, points[0].dy);
      for (var point in points) {
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawPath(path, linePaint);
    }

    // Dibujar los puntos y las etiquetas
    for (int i = 0; i < employeeSalaries.length; i++) {
      // Dibujar los puntos
      Paint pointPaint = Paint()..color = Colors.blue;
      canvas.drawCircle(points[i], 6, pointPaint); // Puntos más grandes

      // Dibujar etiqueta de salario
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: '\$${employeeSalaries[i].toStringAsFixed(0)}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ), // Aumentar tamaño fuente
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          points[i].dx - textPainter.width / 2,
          points[i].dy - 25,
        ), // Ajustar posición etiqueta
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// Clase para dibujar el gráfico de líneas de cantidad de productos
class ProductChartPainter extends CustomPainter {
  final List<double> productQuantities;
  final bool isLineChart;

  ProductChartPainter(this.productQuantities, {this.isLineChart = false});

  @override
  void paint(Canvas canvas, Size size) {
    if (productQuantities.isEmpty) {
      return;
    }

    double maxQuantity = productQuantities.reduce(max);
    double availableHeight = size.height - 30;
    double xSpace = size.width / (productQuantities.length - 1);

    List<Offset> points = [];
    for (int i = 0; i < productQuantities.length; i++) {
      double x = i * xSpace;
      double y =
          size.height -
          (productQuantities[i] / maxQuantity) * availableHeight -
          20;
      points.add(Offset(x, y));
    }

    // Dibujar la línea
    Paint linePaint =
        Paint()
          ..color = Colors.green
          ..style = PaintingStyle.stroke
          ..strokeWidth =
              3 // Línea más gruesa
          ..strokeCap = StrokeCap.round; // Línea redondeada

    if (isLineChart) {
      Path path = Path();
      path.moveTo(points[0].dx, points[0].dy);
      for (var point in points) {
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawPath(path, linePaint);
    }

    // Dibujar los puntos y las etiquetas
    for (int i = 0; i < productQuantities.length; i++) {
      // Dibujar los puntos
      Paint pointPaint = Paint()..color = Colors.green;
      canvas.drawCircle(points[i], 6, pointPaint); // Puntos más grandes

      // Dibujar etiqueta de cantidad
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: '${productQuantities[i].toInt()}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ), // Aumentar tamaño fuente
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          points[i].dx - textPainter.width / 2,
          points[i].dy - 25,
        ), // Ajustar posición etiqueta
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// Clase para dibujar el gráfico de líneas de proveedores
class SupplierChartPainter extends CustomPainter {
  final List<String> supplierNames;
  final bool isLineChart;

  SupplierChartPainter(this.supplierNames, {this.isLineChart = false});

  @override
  void paint(Canvas canvas, Size size) {
    if (supplierNames.isEmpty) {
      return;
    }

    double availableHeight = size.height - 30;
    double xSpace = size.width / (supplierNames.length - 1);

    List<Offset> points = [];
    for (int i = 0; i < supplierNames.length; i++) {
      double x = i * xSpace;
      double y =
          size.height -
          (i / supplierNames.length) * availableHeight -
          20; // Suponiendo distribución uniforme
      points.add(Offset(x, y));
    }

    // Dibujar la línea
    Paint linePaint =
        Paint()
          ..color = Colors.orange
          ..style = PaintingStyle.stroke
          ..strokeWidth =
              3 // Línea más gruesa
          ..strokeCap = StrokeCap.round; // Línea redondeada

    if (isLineChart) {
      Path path = Path();
      path.moveTo(points[0].dx, points[0].dy);
      for (var point in points) {
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawPath(path, linePaint);
    }

    // Dibujar los puntos y las etiquetas
    for (int i = 0; i < supplierNames.length; i++) {
      // Dibujar los puntos
      Paint pointPaint = Paint()..color = Colors.orange;
      canvas.drawCircle(points[i], 6, pointPaint); // Puntos más grandes
      // Dibujar etiqueta del nombre del proveedor
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: supplierNames[i],
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ), // Aumentar tamaño fuente
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          points[i].dx - textPainter.width / 2,
          points[i].dy - 25,
        ), // Ajustar posición etiqueta
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
