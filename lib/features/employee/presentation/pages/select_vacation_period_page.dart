import 'package:flutter/material.dart';
import 'package:nexuserp/features/employee/domain/entities/employee.dart';
import 'package:nexuserp/features/vacation/data/datasources/vacation_service.dart';
import 'package:nexuserp/features/vacation/domain/entities/vacation.dart';
import 'package:nexuserp/features/vacation/data/repositories/vacation_repository_impl.dart';
import 'package:intl/intl.dart'; // Importar para formatear fechas

// Esta página permite al empleado seleccionar un período de vacaciones
// y enviarlo para su aprobación.
class SelectVacationPeriodPage extends StatefulWidget {
  final Employee employee;

  const SelectVacationPeriodPage({super.key, required this.employee});

  @override
  State<SelectVacationPeriodPage> createState() =>
      _SelectVacationPeriodPageState();
}

class _SelectVacationPeriodPageState extends State<SelectVacationPeriodPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  late final VacationRepositoryImpl _vacationRepository;
  bool _isLoading = false; // Estado para controlar el indicador de carga

  @override
  void initState() {
    super.initState();
    _vacationRepository = VacationRepositoryImpl(VacationService());
  }

  // Función para seleccionar una fecha usando un DatePicker.
  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade700, // Color primario del DatePicker
              onPrimary: Colors.white, // Color del texto en el primario
              surface: Colors.white, // Color de fondo del DatePicker
              onSurface: Colors.black87, // Color del texto en la superficie
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    Colors.blue.shade700, // Color de los botones de texto
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          // Si la fecha de inicio es posterior a la de fin, ajusta la de fin
          if (_endDate != null && _startDate!.isAfter(_endDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
          // Si la fecha de fin es anterior a la de inicio, ajusta la de inicio
          if (_startDate != null && _endDate!.isBefore(_startDate!)) {
            _startDate = null;
          }
        }
      });
    }
  }

  // Función para guardar la solicitud de vacaciones.
  Future<void> _save() async {
    if (_startDate == null || _endDate == null) {
      _showSnackBar(
        'Por favor, selecciona tanto la fecha de inicio como la de fin.',
      );
      return;
    }
    if (_startDate!.isAfter(_endDate!)) {
      _showSnackBar(
        'La fecha de inicio no puede ser posterior a la fecha de fin.',
      );
      return;
    }

    setState(() {
      _isLoading = true; // Inicia el indicador de carga
    });

    try {
      final vacation = Vacation(
        employeeName: widget.employee.nombreCompleto,
        employeeDni: widget.employee.dni,
        startDate: _startDate!,
        endDate: _endDate!,
        status: 'Pendiente', // Estado inicial de la solicitud
      );

      await _vacationRepository.addVacation(vacation);

      if (mounted) {
        _showSnackBar(
          'Solicitud de vacaciones enviada con éxito.',
          isError: false,
        );
        Navigator.pop(context, vacation); // Vuelve a la página anterior
      }
    } catch (e) {
      _showSnackBar('Error al enviar la solicitud: $e');
    } finally {
      setState(() {
        _isLoading = false; // Detiene el indicador de carga
      });
    }
  }

  // Muestra un SnackBar con un mensaje.
  void _showSnackBar(String message, {bool isError = true}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor:
              isError ? Colors.red.shade600 : Colors.green.shade600,
          behavior: SnackBarBehavior.floating, // Hace que el SnackBar flote
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Vacaciones - ${widget.employee.nombreCompleto.split(' ').first}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 8,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24), // Padding uniforme.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              'Selecciona el período de las vacaciones de ${widget.employee.nombreCompleto.split(' ').first}',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Tarjeta para la selección de la fecha de inicio.
            _buildDateSelectionCard(
              context,
              icon: Icons.date_range,
              label: 'Fecha de Inicio',
              date: _startDate,
              onTap: () => _selectDate(context, true),
              iconColor: Colors.green.shade600,
            ),
            const SizedBox(height: 20),

            // Tarjeta para la selección de la fecha de fin.
            _buildDateSelectionCard(
              context,
              icon: Icons.date_range,
              label: 'Fecha de Fin',
              date: _endDate,
              onTap: () => _selectDate(context, false),
              iconColor: Colors.orange.shade600,
            ),
            const SizedBox(height: 40),

            // Botón para guardar la solicitud de vacaciones.
            ElevatedButton.icon(
              onPressed:
                  _isLoading
                      ? null
                      : _save, // Deshabilita el botón si está cargando
              icon:
                  _isLoading
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : const Icon(
                        Icons.send_rounded,
                        size: 24,
                      ), // Icono de envío
              label: Text(
                _isLoading ? 'Enviando...' : 'Enviar Solicitud',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.blue.shade700, // Color de fondo del botón
                foregroundColor: Colors.white, // Color del texto/icono
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Bordes redondeados
                ),
                elevation: 8, // Sombra del botón
                shadowColor: Colors.blue.shade900.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para construir una tarjeta de selección de fecha.
  Widget _buildDateSelectionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    required Color iconColor,
  }) {
    return Card(
      elevation: 5, // Sombra para la tarjeta
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, size: 30, color: iconColor),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date != null
                          ? DateFormat('dd/MM/yyyy').format(
                            date,
                          ) // Formato de fecha legible
                          : 'Toca para seleccionar',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
