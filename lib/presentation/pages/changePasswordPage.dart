import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nexuserp/core/utils/password_visibility_controller.dart';

class ChangePasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PasswordVisibilityController(),
      child: const ChangePasswordForm(),
    );
  }
}

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({Key? key}) : super(key: key);

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final supabase = Supabase.instance.client;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await supabase.auth.updateUser(
          UserAttributes(password: _passwordController.text),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contraseña actualizada correctamente'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green, // Color de éxito
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar la contraseña: ${e.toString()}'),
            duration: const Duration(
              seconds: 5,
            ), // Duración más larga para errores
            backgroundColor: Colors.red, // Color de error
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  InputDecoration _inputDecoration(
    String label,
    PasswordVisibilityController controller,
  ) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white, // Cambiado a blanco para mejor contraste
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Colors.blue.shade500,
        ), // Borde azul por defecto
      ),
      enabledBorder: OutlineInputBorder(
        // Definir explícitamente el borde habilitado
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Colors.blue.shade500,
        ), // Borde azul por defecto
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Colors.blue.shade700, // Color de enfoque más oscuro
          width: 2, // Borde de enfoque ligeramente más grueso
        ),
      ),
      errorBorder: OutlineInputBorder(
        // Definir borde de error
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        // Definir borde de error enfocado
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      suffixIcon: IconButton(
        icon: Icon(
          controller.isObscured
              ? Icons.visibility_off_rounded
              : Icons.visibility_rounded, // Usar iconos redondeados
          color: Colors.grey.shade500, // Color de icono más sutil
        ),
        onPressed: controller.toggleVisibility,
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 20,
      ), // Mayor padding
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibilityController = Provider.of<PasswordVisibilityController>(
      context,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Fondo claro
      appBar: AppBar(
        title: const Text(
          'Cambiar Contraseña',
          style: TextStyle(
            color: Colors.white, // Color de título blanco
            fontWeight: FontWeight.w600, // Título ligeramente más negrita
          ),
        ),
        backgroundColor: Colors.blue.shade700, // Barra de aplicación azul
        iconTheme: const IconThemeData(
          color: Colors.white, // Color de icono blanco
        ),
        elevation:
            0, // Sombra de la barra de aplicación eliminada para un aspecto limpio
        centerTitle: true, // Centrar el título
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Asegura tu cuenta',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A202C),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Introduce tu nueva contraseña a continuación para actualizarla.',
                  style: TextStyle(fontSize: 16, color: Color(0xFF4A5568)),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _passwordController,
                  obscureText: visibilityController.isObscured,
                  decoration: _inputDecoration(
                    'Nueva Contraseña',
                    visibilityController,
                  ),
                  validator: (value) {
                    if (value == null || value.length < 8) {
                      return 'La contraseña debe tener al menos 8 caracteres';
                    }
                    return null;
                  },
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: visibilityController.isObscured,
                  decoration: _inputDecoration(
                    'Confirmar Contraseña',
                    visibilityController,
                  ),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _changePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor:
                          Colors.white, // Color del texto del botón
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation:
                          4, // Elevación aumentada para un botón más prominente
                      shadowColor: Colors.blue.withOpacity(
                        0.3,
                      ), // Sombra más pronunciada
                    ),
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            )
                            : const Text(
                              'Actualizar Contraseña',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
