import 'package:flutter/material.dart';
import 'package:nexuserp/features/employee/domain/entities/employee.dart';
import 'package:nexuserp/features/employee/presentation/pages/select_vacation_period_page.dart';
import 'package:nexuserp/features/employee_files/presentation/pages/upload_employee_file_page.dart';
import 'package:nexuserp/presentation/pages/login.dart';

// Esta clase representa una página de opciones rápidas para un empleado.
// Muestra un saludo personalizado y botones para acciones comunes como
// solicitar vacaciones, subir archivos y cerrar sesión.
class EmployeeSimpleOptionsPage extends StatelessWidget {
  final Employee employee;

  // Constructor que requiere un objeto Employee.
  const EmployeeSimpleOptionsPage({Key? key, required this.employee})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Configuración de la barra de aplicación (AppBar).
      appBar: AppBar(
        // Título de la AppBar, mostrando el nombre completo del empleado.
        title: Text(
          'Opciones de ${employee.nombreCompleto}',
          style: const TextStyle(
            color: Colors.white, // Texto blanco para contraste.
            fontWeight: FontWeight.w600, // Fuente un poco más negrita.
            letterSpacing:
                0.8, // Espaciado entre letras para mejor legibilidad.
          ),
        ),
        // Personalización del fondo de la AppBar con un gradiente.
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade700,
                Colors.blue.shade900,
              ], // Gradiente de azul oscuro a más oscuro.
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 8, // Sombra para dar profundidad a la AppBar.
      ),
      // Cuerpo de la página.
      body: SingleChildScrollView(
        // Permite desplazamiento si el contenido es largo.
        padding: const EdgeInsets.symmetric(
          vertical: 40,
          horizontal: 24,
        ), // Mayor padding vertical.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // Estira los hijos horizontalmente.
          children: [
            // Icono decorativo o elemento visual.
            Icon(
              Icons
                  .person_pin_circle, // Icono de persona para dar un toque visual.
              size: 100,
              color: Colors.blue.shade400,
            ),
            const SizedBox(height: 24), // Espacio después del icono.
            // Mensaje de bienvenida personalizado.
            Text(
              '¡Bienvenido, ${employee.nombreCompleto.split(' ').first}!',
              style: TextStyle(
                fontSize: 32, // Tamaño de fuente más grande.
                fontWeight: FontWeight.w800, // Más negrita.
                color: Colors.blue.shade800, // Azul más oscuro.
                letterSpacing: 1.5, // Mayor espaciado para el título.
                shadows: [
                  // Sombra de texto sutil.
                  Shadow(
                    offset: const Offset(1, 1),
                    blurRadius: 2.0,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12), // Espacio.
            // Subtítulo descriptivo.
            Text(
              'Accede rápidamente a tus opciones de empleado',
              style: TextStyle(
                fontSize: 18, // Tamaño de fuente ligeramente más grande.
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic, // Texto en cursiva.
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48), // Mayor espacio antes de los botones.
            // Botón para la opción de Vacaciones.
            _buildOptionButton(
              context,
              icon: Icons.calendar_today, // Icono ligeramente diferente.
              label: 'Solicitar Vacaciones',
              color: Colors.green.shade50, // Color de fondo más claro.
              iconColor: Colors.green.shade700,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => SelectVacationPeriodPage(employee: employee),
                    ),
                  ),
            ),
            const SizedBox(height: 20), // Espacio entre botones.
            // Botón para la opción de Subir Archivo.
            _buildOptionButton(
              context,
              icon: Icons.cloud_upload, // Icono de subida a la nube.
              label: 'Subir Documento',
              color: Colors.purple.shade50,
              iconColor: Colors.purple.shade700,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => UploadEmployeeFilePage(
                            employeeId: employee.id!,
                            employeeName: employee.nombreCompleto,
                          ),
                    ),
                  ),
            ),
            const SizedBox(height: 20), // Espacio entre botones.
            // Botón para la opción de Cerrar Sesión.
            _buildOptionButton(
              context,
              icon: Icons.exit_to_app, // Icono de salida.
              label: 'Cerrar Sesión',
              color: Colors.red.shade50,
              iconColor: Colors.red.shade700,
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => LoginScreen(),
                  ), // Asegúrate de que LoginScreen sea const si es posible.
                  (route) => false, // Elimina todas las rutas anteriores.
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para construir un botón de opción con estilo mejorado.
  Widget _buildOptionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(20), // Bordes más redondeados.
      elevation: 0, // Eliminamos la elevación por defecto de Material.
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        splashColor: iconColor.withOpacity(0.2), // Color de "splash" al tocar.
        highlightColor: iconColor.withOpacity(
          0.1,
        ), // Color de "highlight" al mantener presionado.
        child: Container(
          // Decoración del contenedor para añadir sombra personalizada.
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                  0.08,
                ), // Sombra más sutil y extendida.
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 5), // Desplazamiento de la sombra.
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 20,
          ), // Padding ajustado.
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 36), // Icono más grande.
              const SizedBox(width: 20), // Espacio entre icono y texto.
              Text(
                label,
                style: TextStyle(
                  fontSize: 22, // Texto más grande.
                  fontWeight: FontWeight.w700, // Más negrita.
                  color: iconColor,
                  letterSpacing: 0.5, // Espaciado de letras.
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
