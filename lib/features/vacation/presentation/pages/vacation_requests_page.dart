import 'package:flutter/material.dart';
import 'package:nexuserp/features/vacation/domain/entities/vacation.dart';
import 'package:nexuserp/core/utils/vacations_strings.dart';

class VacationRequestsPage extends StatelessWidget {
  final List<Vacation> requests;
  const VacationRequestsPage({Key? key, required this.requests})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = (width / 320).floor().clamp(1, 4);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          VacationsStrings.requestsTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: Colors.white,
            shadows: [
              Shadow(
                offset: Offset(2.0, 2.0),
                blurRadius: 3.0,
                color: Colors.black45,
              ),
            ],
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade900,
                Colors.blue.shade600,
                Colors.blue.shade400,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
        ),
        elevation: 12,
      ),
      body:
          requests.isEmpty
              ? Center(
                child: Text(
                  VacationsStrings.noRequests,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(12),
                child: GridView.builder(
                  itemCount: requests.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 2.1,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final v = requests[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: _getStatusColor(
                                    v.status,
                                  ).withOpacity(0.2),
                                  child: Icon(
                                    _getStatusIcon(v.status),
                                    color: _getStatusColor(v.status),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    v.employeeName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(
                                      v.status,
                                    ).withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    v.status.toUpperCase(),
                                    style: TextStyle(
                                      color: _getStatusColor(v.status),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 15,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${v.startDate.day.toString().padLeft(2, '0')}/${v.startDate.month.toString().padLeft(2, '0')}/${v.startDate.year}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.arrow_forward,
                                  size: 15,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${v.endDate.day.toString().padLeft(2, '0')}/${v.endDate.month.toString().padLeft(2, '0')}/${v.endDate.year}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'aprobada':
        return Colors.green.shade400;
      case 'rechazada':
        return Colors.red.shade400;
      case 'pendiente':
        return Colors.yellow.shade700;
      default:
        return Colors.grey.shade400;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'aprobada':
        return Icons.check_circle;
      case 'rechazada':
        return Icons.cancel;
      case 'pendiente':
        return Icons.hourglass_empty;
      default:
        return Icons.info_outline;
    }
  }
}
