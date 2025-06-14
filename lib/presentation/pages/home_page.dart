import 'package:flutter/material.dart';
import 'dart:math';

import 'package:nexuserp/features/employee/domain/entities/employee.dart';
import 'package:nexuserp/features/product/domain/entities/product.dart';
import 'package:nexuserp/features/product/data/datasources/product_service.dart';
import '../../features/employee/data/datasources/employee_service.dart';
import '../../core/utils/home_page_strings.dart';

// Enum para los tipos de gráfico
enum ChartType { line, pie }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Employee> _employees = [];
  List<Product> _products = [];

  final EmployeeService _employeeService = EmployeeService();
  final ProductService _productService = ProductService();

  // Estados para controlar el tipo de gráfico seleccionado para cada sección
  ChartType _employeeChartType = ChartType.line;
  ChartType _productChartType = ChartType.line;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final employeeModels = await _employeeService.fetchEmployees();
      final productModels = await _productService.fetchProducts();

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
      });
    } catch (e) {
      debugPrint('Error loading data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(HomePageStrings.loadingError),
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bool isLargeScreen = constraints.maxWidth > 600;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sección de gráficos
                  isLargeScreen
                      ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildChartSection(
                              title: HomePageStrings.employeeChart,
                              isEmpty: _employees.isEmpty,
                              emptyMessage: HomePageStrings.employeeEmpty,
                              chartType: _employeeChartType,
                              onChartTypeChanged: (type) {
                                setState(() {
                                  _employeeChartType = type;
                                });
                              },
                              lineChartBuilder:
                                  (constraints) => CustomPaint(
                                    painter: EmployeeLineChartPainter(
                                      _employees.map((e) => e.sueldo).toList(),
                                    ),
                                    size: Size(
                                      constraints.maxWidth,
                                      constraints.maxHeight,
                                    ),
                                  ),
                              pieChartBuilder:
                                  (constraints) => CustomPaint(
                                    painter: EmployeePieChartPainter(
                                      _employees,
                                    ),
                                    size: Size(
                                      constraints.maxWidth,
                                      constraints.maxHeight,
                                    ),
                                  ),
                            ),
                          ),
                          Expanded(
                            child: _buildChartSection(
                              title: HomePageStrings.productChart,
                              isEmpty: _products.isEmpty,
                              emptyMessage: HomePageStrings.productEmpty,
                              chartType: _productChartType,
                              onChartTypeChanged: (type) {
                                setState(() {
                                  _productChartType = type;
                                });
                              },
                              lineChartBuilder:
                                  (constraints) => CustomPaint(
                                    painter: ProductLineChartPainter(
                                      _products
                                          .map((p) => p.cantidad.toDouble())
                                          .toList(),
                                    ),
                                    size: Size(
                                      constraints.maxWidth,
                                      constraints.maxHeight,
                                    ),
                                  ),
                              pieChartBuilder:
                                  (constraints) => CustomPaint(
                                    painter: ProductPieChartPainter(_products),
                                    size: Size(
                                      constraints.maxWidth,
                                      constraints.maxHeight,
                                    ),
                                  ),
                            ),
                          ),
                        ],
                      )
                      : Column(
                        children: [
                          _buildChartSection(
                            title: HomePageStrings.employeeChart,
                            isEmpty: _employees.isEmpty,
                            emptyMessage: HomePageStrings.employeeEmpty,
                            chartType: _employeeChartType,
                            onChartTypeChanged: (type) {
                              setState(() {
                                _employeeChartType = type;
                              });
                            },
                            lineChartBuilder:
                                (constraints) => CustomPaint(
                                  painter: EmployeeLineChartPainter(
                                    _employees.map((e) => e.sueldo).toList(),
                                  ),
                                  size: Size(
                                    constraints.maxWidth,
                                    constraints.maxHeight,
                                  ),
                                ),
                            pieChartBuilder:
                                (constraints) => CustomPaint(
                                  painter: EmployeePieChartPainter(_employees),
                                  size: Size(
                                    constraints.maxWidth,
                                    constraints.maxHeight,
                                  ),
                                ),
                          ),
                          const SizedBox(height: 24.0),
                          _buildChartSection(
                            title: HomePageStrings.productChart,
                            isEmpty: _products.isEmpty,
                            emptyMessage: HomePageStrings.productEmpty,
                            chartType: _productChartType,
                            onChartTypeChanged: (type) {
                              setState(() {
                                _productChartType = type;
                              });
                            },
                            lineChartBuilder:
                                (constraints) => CustomPaint(
                                  painter: ProductLineChartPainter(
                                    _products
                                        .map((p) => p.cantidad.toDouble())
                                        .toList(),
                                  ),
                                  size: Size(
                                    constraints.maxWidth,
                                    constraints.maxHeight,
                                  ),
                                ),
                            pieChartBuilder:
                                (constraints) => CustomPaint(
                                  painter: ProductPieChartPainter(_products),
                                  size: Size(
                                    constraints.maxWidth,
                                    constraints.maxHeight,
                                  ),
                                ),
                          ),
                        ],
                      ),
                  const SizedBox(height: 24.0),
                  // Nuevo contenido añadido aquí
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      HomePageStrings.addContent,
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      // El FloatingActionButton ha sido eliminado para optimización
    );
  }

  Widget _buildChartSection({
    required String title,
    required bool isEmpty,
    required String emptyMessage,
    required ChartType chartType,
    required ValueChanged<ChartType> onChartTypeChanged,
    required Widget Function(BoxConstraints) lineChartBuilder,
    required Widget Function(BoxConstraints) pieChartBuilder,
  }) {
    String currentChartTitle;
    if (title == HomePageStrings.employeeChart) {
      currentChartTitle =
          chartType == ChartType.line
              ? HomePageStrings.employeeChartLine
              : HomePageStrings.employeeChartPie;
    } else if (title == HomePageStrings.productChart) {
      currentChartTitle =
          chartType == ChartType.line
              ? HomePageStrings.productChartLine
              : HomePageStrings.productChartPie;
    } else {
      currentChartTitle = title;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.blue,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child:
                    isEmpty
                        ? _buildEmptyState(emptyMessage)
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentChartTitle,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  if (chartType == ChartType.line) {
                                    return lineChartBuilder(constraints);
                                  } else {
                                    return pieChartBuilder(constraints);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final bool showTextLabels =
                                    constraints.maxWidth > 400;
                                final double fontSize = showTextLabels ? 14 : 0;
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SegmentedButton<ChartType>(
                                      segments: <ButtonSegment<ChartType>>[
                                        ButtonSegment<ChartType>(
                                          value: ChartType.line,
                                          label:
                                              showTextLabels
                                                  ? Text(
                                                    HomePageStrings.line,
                                                    style: TextStyle(
                                                      fontSize: fontSize,
                                                    ),
                                                  )
                                                  : null,
                                          icon: const Icon(Icons.show_chart),
                                        ),
                                        ButtonSegment<ChartType>(
                                          value: ChartType.pie,
                                          label:
                                              showTextLabels
                                                  ? Text(
                                                    HomePageStrings.pie,
                                                    style: TextStyle(
                                                      fontSize: fontSize,
                                                    ),
                                                  )
                                                  : null,
                                          icon: const Icon(Icons.pie_chart),
                                        ),
                                      ],
                                      selected: <ChartType>{chartType},
                                      onSelectionChanged: (
                                        Set<ChartType> newSelection,
                                      ) {
                                        onChartTypeChanged(newSelection.first);
                                      },
                                      style: SegmentedButton.styleFrom(
                                        backgroundColor: Colors.blue.shade50,
                                        selectedBackgroundColor:
                                            Colors.blue.shade100,
                                        selectedForegroundColor:
                                            Colors.blue.shade800,
                                        foregroundColor: Colors.blue.shade600,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
              ),
            ),
          ),
        ),
      ],
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
}

// Clase para dibujar el gráfico de líneas de salarios de empleados
class EmployeeLineChartPainter extends CustomPainter {
  final List<double> employeeSalaries;

  EmployeeLineChartPainter(this.employeeSalaries);

  @override
  void paint(Canvas canvas, Size size) {
    if (employeeSalaries.isEmpty) {
      return;
    }

    double maxSalary = employeeSalaries.reduce(max);
    double availableHeight = size.height - 30; // Espacio para etiquetas

    double xStep;
    if (employeeSalaries.length <= 1) {
      xStep = size.width / 2; // Centrar el único punto
    } else {
      xStep = size.width / (employeeSalaries.length - 1);
    }

    List<Offset> points = [];
    for (int i = 0; i < employeeSalaries.length; i++) {
      double x = (employeeSalaries.length <= 1) ? size.width / 2 : i * xStep;
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
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round;

    Path path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points[0].dx, points[0].dy);
      for (var i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }
    canvas.drawPath(path, linePaint);

    // Adaptive Labeling
    double minLabelWidth =
        60.0; // Ancho mínimo estimado para una etiqueta numérica
    int maxLabelsThatFit = (size.width / minLabelWidth).floor();
    if (maxLabelsThatFit == 0)
      maxLabelsThatFit = 1; // Asegurar al menos una etiqueta

    int labelDrawInterval = (employeeSalaries.length / maxLabelsThatFit)
        .ceil()
        .clamp(1, employeeSalaries.length);

    for (int i = 0; i < employeeSalaries.length; i++) {
      // Dibujar etiqueta solo si está en el intervalo o es el último punto
      if (i % labelDrawInterval == 0 || i == employeeSalaries.length - 1) {
        // Dibujar el punto grande y opaco
        Paint pointPaint = Paint()..color = Colors.blue;
        canvas.drawCircle(points[i], 6, pointPaint);

        // Dibujar etiqueta de salario
        TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: '\$${employeeSalaries[i].toStringAsFixed(0)}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12, // Tamaño de fuente ligeramente más pequeño
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(points[i].dx - textPainter.width / 2, points[i].dy - 25),
        );
      } else {
        // Dibujar un punto más pequeño y semitransparente para los puntos sin etiqueta
        Paint pointPaint = Paint()..color = Colors.blue.withOpacity(0.5);
        canvas.drawCircle(points[i], 4, pointPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// Clase para dibujar el gráfico circular de empleados (Activos vs Inactivos)
class EmployeePieChartPainter extends CustomPainter {
  final List<Employee> employees;

  EmployeePieChartPainter(this.employees);

  @override
  void paint(Canvas canvas, Size size) {
    if (employees.isEmpty) {
      return;
    }

    final int activeCount = employees.where((e) => e.activo).length;
    final int inactiveCount = employees.length - activeCount;

    final List<PieData> pieData = [];
    if (activeCount > 0) {
      pieData.add(PieData('Activos', activeCount.toDouble(), Colors.green));
    }
    if (inactiveCount > 0) {
      pieData.add(PieData('Inactivos', inactiveCount.toDouble(), Colors.red));
    }

    if (pieData.isEmpty) {
      return;
    }

    final double total = pieData
        .map((data) => data.value)
        .fold(0.0, (a, b) => a + b);
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2) * 0.8;

    double startAngle = -pi / 2; // Start from top

    for (var data in pieData) {
      final double sweepAngle = (data.value / total) * 2 * pi;
      final Paint paint = Paint()..color = data.color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Dibujar etiquetas de porcentaje
      final double midAngle = startAngle + sweepAngle / 2;
      final double labelX = center.dx + radius * 0.6 * cos(midAngle);
      final double labelY = center.dy + radius * 0.6 * sin(midAngle);

      final textSpan = TextSpan(
        text: '${(data.value / total * 100).toStringAsFixed(1)}%',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(labelX - textPainter.width / 2, labelY - textPainter.height / 2),
      );

      startAngle += sweepAngle;
    }

    // Dibujar leyenda
    double legendY = size.height - 20;
    double legendX = 10;
    for (var data in pieData) {
      canvas.drawRect(
        Rect.fromLTWH(legendX, legendY, 10, 10),
        Paint()..color = data.color,
      );
      final textSpan = TextSpan(
        text: data.label,
        style: const TextStyle(color: Colors.black, fontSize: 10),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(legendX + 15, legendY - 2));
      legendX +=
          textPainter.width + 30; // Espacio entre elementos de la leyenda
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// Clase para dibujar el gráfico de líneas de cantidad de productos
class ProductLineChartPainter extends CustomPainter {
  final List<double> productQuantities;

  ProductLineChartPainter(this.productQuantities);

  @override
  void paint(Canvas canvas, Size size) {
    if (productQuantities.isEmpty) {
      return;
    }

    double maxQuantity = productQuantities.reduce(max);
    double availableHeight = size.height - 30;

    double xStep;
    if (productQuantities.length <= 1) {
      xStep = size.width / 2; // Centrar el único punto
    } else {
      xStep = size.width / (productQuantities.length - 1);
    }

    List<Offset> points = [];
    for (int i = 0; i < productQuantities.length; i++) {
      double x = (productQuantities.length <= 1) ? size.width / 2 : i * xStep;
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
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round;

    Path path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points[0].dx, points[0].dy);
      for (var i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }
    canvas.drawPath(path, linePaint);

    // Adaptive Labeling
    double minLabelWidth =
        60.0; // Ancho mínimo estimado para una etiqueta numérica
    int maxLabelsThatFit = (size.width / minLabelWidth).floor();
    if (maxLabelsThatFit == 0) maxLabelsThatFit = 1;

    int labelDrawInterval = (productQuantities.length / maxLabelsThatFit)
        .ceil()
        .clamp(1, productQuantities.length);

    for (int i = 0; i < productQuantities.length; i++) {
      if (i % labelDrawInterval == 0 || i == productQuantities.length - 1) {
        // Dibujar el punto grande y opaco
        Paint pointPaint = Paint()..color = Colors.green;
        canvas.drawCircle(points[i], 6, pointPaint);

        // Dibujar etiqueta de cantidad
        TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: '${productQuantities[i].toInt()}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12, // Tamaño de fuente ligeramente más pequeño
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(points[i].dx - textPainter.width / 2, points[i].dy - 25),
        );
      } else {
        // Dibujar un punto más pequeño y semitransparente
        Paint pointPaint = Paint()..color = Colors.green.withOpacity(0.5);
        canvas.drawCircle(points[i], 4, pointPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// Clase para dibujar el gráfico circular de productos (por tipo)
class ProductPieChartPainter extends CustomPainter {
  final List<Product> products;

  ProductPieChartPainter(this.products);

  @override
  void paint(Canvas canvas, Size size) {
    if (products.isEmpty) {
      return;
    }

    final Map<String, double> typeCounts = {};
    for (var product in products) {
      typeCounts[product.tipo as String] = (typeCounts[product.tipo] ?? 0) + 1;
    }

    final List<PieData> pieData =
        typeCounts.entries.map((entry) {
          return PieData(
            entry.key,
            entry.value,
            _getColorForProductType(entry.key),
          );
        }).toList();

    if (pieData.isEmpty) {
      return;
    }

    final double total = pieData
        .map((data) => data.value)
        .fold(0.0, (a, b) => a + b);
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2) * 0.8;

    double startAngle = -pi / 2;

    for (var data in pieData) {
      final double sweepAngle = (data.value / total) * 2 * pi;
      final Paint paint = Paint()..color = data.color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Dibujar etiquetas de porcentaje
      final double midAngle = startAngle + sweepAngle / 2;
      final double labelX = center.dx + radius * 0.6 * cos(midAngle);
      final double labelY = center.dy + radius * 0.6 * sin(midAngle);

      final textSpan = TextSpan(
        text: '${(data.value / total * 100).toStringAsFixed(1)}%',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(labelX - textPainter.width / 2, labelY - textPainter.height / 2),
      );

      startAngle += sweepAngle;
    }

    // Dibujar leyenda
    double legendY = size.height - 20;
    double legendX = 10;
    for (var data in pieData) {
      canvas.drawRect(
        Rect.fromLTWH(legendX, legendY, 10, 10),
        Paint()..color = data.color,
      );
      final textSpan = TextSpan(
        text: data.label,
        style: const TextStyle(color: Colors.black, fontSize: 10),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(legendX + 15, legendY - 2));
      legendX += textPainter.width + 30;
    }
  }

  Color _getColorForProductType(String type) {
    // Genera un color basado en un hash del tipo para consistencia
    final int hash = type.hashCode;
    final Random random = Random(hash);
    return Color.fromARGB(
      255,
      random.nextInt(200) + 50, // Evitar colores muy oscuros
      random.nextInt(200) + 50,
      random.nextInt(200) + 50,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// Clase de datos para los gráficos circulares
class PieData {
  final String label;
  final double value;
  final Color color;

  PieData(this.label, this.value, this.color);
}
