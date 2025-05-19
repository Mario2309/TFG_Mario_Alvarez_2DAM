import 'package:flutter/material.dart';

class VacationRequestPage extends StatefulWidget {
  final String employeeDni;
  final String employeeName;

  const VacationRequestPage({
    Key? key,
    required this.employeeDni,
    required this.employeeName,
  }) : super(key: key);

  @override
  _VacationRequestPageState createState() => _VacationRequestPageState();
}

class _VacationRequestPageState extends State<VacationRequestPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _observationsController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _pickStartDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked;
        // Si la fecha de fin es anterior, la reseteamos
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _pickEndDate() async {
    if (_startDate == null) {
      // Mostrar alerta para que el usuario elija primero la fecha de inicio
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecciona primero la fecha de inicio'),
        ),
      );
      return;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate!,
      firstDate: _startDate!,
      lastDate: DateTime(_startDate!.year + 2),
    );

    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _submitRequest() async {
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona ambas fechas')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Aquí llamarías al repositorio o servicio para enviar la solicitud de vacaciones
      // Por ejemplo:
      // await vacationRepository.addVacation(Vacation(...));

      // Simulamos una espera
      await Future.delayed(const Duration(seconds: 1));

      // Mostrar mensaje éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Solicitud de vacaciones enviada con éxito'),
        ),
      );

      Navigator.pop(
        context,
        true,
      ); // Puedes devolver true para refrescar si quieres
    } catch (e) {
      // Manejo de error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al enviar solicitud: $e')));
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  void dispose() {
    _observationsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitar Vacaciones')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Empleado: ${widget.employeeName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),

            // Fecha de inicio
            ListTile(
              title: const Text('Fecha de inicio'),
              subtitle: Text(
                _startDate == null
                    ? 'Selecciona la fecha de inicio'
                    : _startDate!.toLocal().toString().split(' ')[0],
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: _pickStartDate,
            ),

            // Fecha fin
            ListTile(
              title: const Text('Fecha de fin'),
              subtitle: Text(
                _endDate == null
                    ? 'Selecciona la fecha de fin'
                    : _endDate!.toLocal().toString().split(' ')[0],
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: _pickEndDate,
            ),

            const SizedBox(height: 20),

            // Observaciones
            TextField(
              controller: _observationsController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Observaciones (opcional)',
                border: OutlineInputBorder(),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon:
                    _isSubmitting
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Icon(Icons.send),
                label: const Text('Enviar solicitud'),
                onPressed: _isSubmitting ? null : _submitRequest,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
