import 'package:flutter/material.dart';
import '../../../../core/utils/vacation_request_strings.dart';

/// Página para solicitar vacaciones de un empleado.
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

  /// Permite seleccionar la fecha de inicio de las vacaciones.
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
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = null;
        }
      });
    }
  }

  /// Permite seleccionar la fecha de fin de las vacaciones.
  Future<void> _pickEndDate() async {
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(VacationRequestStrings.selectStartFirst)),
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

  /// Envía la solicitud de vacaciones si los datos son válidos.
  void _submitRequest() async {
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(VacationRequestStrings.selectBothDates)),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await Future.delayed(const Duration(seconds: 1));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(VacationRequestStrings.success)),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${VacationRequestStrings.error} $e')),
      );
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
      appBar: AppBar(title: const Text(VacationRequestStrings.pageTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '${VacationRequestStrings.employeeLabel}: ${widget.employeeName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text(VacationRequestStrings.startDate),
              subtitle: Text(
                _startDate == null
                    ? VacationRequestStrings.selectStartDate
                    : _startDate!.toLocal().toString().split(' ')[0],
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickStartDate,
            ),
            ListTile(
              title: const Text(VacationRequestStrings.endDate),
              subtitle: Text(
                _endDate == null
                    ? VacationRequestStrings.selectEndDate
                    : _endDate!.toLocal().toString().split(' ')[0],
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickEndDate,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _observationsController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: VacationRequestStrings.observations,
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
                label: const Text(VacationRequestStrings.sendRequest),
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
