import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nexuserp/presentation/pages/register_screen.dart';
import 'package:nexuserp/presentation/pages/main_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nexuserp/core/utils/password_visibility_controller.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:animated_text_kit/animated_text_kit.dart'; // Importa para el texto animado
import 'package:another_flushbar/flushbar.dart'; // Import para las notificaciones
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:nexuserp/features/employee/domain/entities/employee.dart';
import 'package:nexuserp/features/employee/presentation/pages/employee_simple_options_page.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PasswordVisibilityController(),
      child: const LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;

  bool _isLoading = false;
  String? _error;
  bool _rememberMe = false; // Estado para "Recordarme"
  late SharedPreferences _prefs;
  bool _isEmployeeLogin = false;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
    initialization(); //inicializar splash
  }

  Future<void> initialization() async {
    // Simula una operación de larga duración (por ejemplo, obtener datos, establecer una conexión).
    await Future.delayed(const Duration(seconds: 1));
    // Una vez completado, elimina el splash.
    FlutterNativeSplash.remove();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadRememberedUser(); // Cargar datos al inicio
  }

  Future<void> _loadRememberedUser() async {
    final rememberedEmail = _prefs.getString('rememberedEmail') ?? '';
    final rememberedPassword = _prefs.getString('rememberedPassword') ?? '';
    final rememberMe = _prefs.getBool('rememberMe') ?? false;

    setState(() {
      _rememberMe = rememberMe;
      _emailController.text = rememberedEmail;
      _passwordController.text = rememberedPassword;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      if (!_isEmployeeLogin) {
        // Login normal Supabase
        final response = await supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );
        if (response.session?.user != null) {
          _rememberMe ? _rememberUser() : _clearRememberedUser();
          _navigateToMainPage();
          return;
        }
      } else {
        // Login empleado (credencial_empleado)
        final credenciales = await Supabase.instance.client
            .from('credencial_empleado')
            .select()
            .eq('correo_electronico', email);
        if (credenciales.isNotEmpty) {
          final credencial = credenciales.first;
          final storedHash = credencial['contrasena_hashed'] ?? '';
          final inputHash = sha256.convert(utf8.encode(password)).toString();
          if (storedHash == inputHash) {
            _rememberMe ? _rememberUser() : _clearRememberedUser();
            // Buscar el empleado por correo electrónico
            final empleados = await Supabase.instance.client
                .from('empleado')
                .select()
                .eq('correo_electronico', email);
            if (empleados.isNotEmpty) {
              final emp = empleados.first;
              final employee = Employee(
                id: emp['id'],
                nombreCompleto: emp['nombre_completo'],
                nacimiento: DateTime.parse(emp['nacimiento']),
                correoElectronico: emp['correo_electronico'],
                numeroTelefono: emp['numero_telefono'],
                dni: emp['dni'],
                sueldo: (emp['sueldo'] as num).toDouble(),
                cargo: emp['cargo'],
                fechaContratacion: DateTime.parse(emp['fecha_contratacion']),
                activo: emp['activo'],
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          EmployeeSimpleOptionsPage(employee: employee),
                ),
              );
              return;
            }
          }
        }
      }
      _showErrorSnackbar(
        context,
        "Inicio de sesión fallido. Por favor, verifica tus credenciales.",
      );
    } catch (e) {
      if (e is AuthException) {
        _showErrorSnackbar(context, e.message);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _rememberUser() async {
    await _prefs.setString('rememberedEmail', _emailController.text.trim());
    await _prefs.setString(
      'rememberedPassword',
      _passwordController.text.trim(),
    );
    await _prefs.setBool('rememberMe', true);
  }

  Future<void> _clearRememberedUser() async {
    await _prefs.remove('rememberedEmail');
    await _prefs.remove('rememberedPassword');
    await _prefs.setBool('rememberMe', false);
  }

  void _navigateToMainPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
    );
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    Flushbar(
      message: message,
      icon: const Icon(Icons.error_outline, color: Colors.red),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red.shade100,
      messageColor: Colors.red.shade900,
    ).show(context);
  }

  Future<void> _signInWithGoogle() async {
    try {
      _showErrorSnackbar(
        context,
        'Inicio de sesión con Google sin implementar',
      );
    } catch (e) {
      _showErrorSnackbar(context, 'Inicio de sesión con Google fallido');
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibilityController = Provider.of<PasswordVisibilityController>(
      context,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            padding: const EdgeInsets.all(24.0),
            constraints: const BoxConstraints(maxWidth: 500),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildHeader(),
                const SizedBox(height: 24.0),
                _buildErrorText(),
                _buildForm(visibilityController),
                const SizedBox(height: 28.0),
                _buildRegisterLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const SizedBox(height: 20.0),
        AnimatedTextKit(
          animatedTexts: [
            TyperAnimatedText(
              'Bienvenido a NexusERP',
              textStyle: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade700,
              ),
              textAlign: TextAlign.center,
              speed: const Duration(milliseconds: 50),
            ),
          ],
          isRepeatingAnimation: false,
          displayFullTextOnTap: true,
        ),
        const SizedBox(height: 8.0),
        const Text(
          'Inicia sesión para continuar',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildErrorText() {
    if (_error == null) return const SizedBox(); //returns empty widget

    return Column(
      children: [
        Text(
          _error!,
          style: const TextStyle(
            color: Colors.red,
          ), // Changed to use default Colors
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12.0),
      ],
    );
  }

  Widget _buildForm(PasswordVisibilityController visibilityController) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _buildEmailField(),
          const SizedBox(height: 16.0),
          _buildPasswordField(visibilityController),
          const SizedBox(height: 12.0),
          _buildRememberMeCheckbox(),
          const SizedBox(height: 16.0),
          _buildLoginButton(),
          const SizedBox(height: 12.0),
          OutlinedButton.icon(
            onPressed:
                _isLoading
                    ? null
                    : () {
                      setState(() {
                        _isEmployeeLogin = !_isEmployeeLogin;
                      });
                    },
            icon: Icon(_isEmployeeLogin ? Icons.person : Icons.verified_user),
            label: Text(_isEmployeeLogin ? 'Empleado' : 'Administrador'),
            style: OutlinedButton.styleFrom(
              foregroundColor:
                  _isEmployeeLogin
                      ? Colors.teal.shade700
                      : Colors.blue.shade700,
              side: BorderSide(
                color:
                    _isEmployeeLogin
                        ? Colors.teal.shade700
                        : Colors.blue.shade700,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          _buildGoogleSignInButton(),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email_outlined),
        labelText: 'Correo electrónico',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        contentPadding: const EdgeInsets.all(16.0),
      ),
      keyboardType: TextInputType.emailAddress,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null) return null;
        if (value.isNotEmpty && !value.contains('@')) {
          return 'Correo inválido';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(
    PasswordVisibilityController visibilityController,
  ) {
    return TextFormField(
      controller: _passwordController,
      obscureText: visibilityController.isObscured,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock_outline),
        labelText: 'Contraseña',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        contentPadding: const EdgeInsets.all(16.0),
        suffixIcon: IconButton(
          icon: Icon(
            visibilityController.isObscured
                ? Icons.visibility_off
                : Icons.visibility,
          ),
          onPressed: visibilityController.toggleVisibility,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Introduce tu contraseña';
        }
        if (value.length < 6) {
          return 'Debe tener al menos 6 caracteres';
        }
        return null;
      },
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _rememberMe,
          onChanged: (value) {
            setState(() {
              _rememberMe = value!;
            });
          },
          checkColor: Colors.white,
          activeColor: const Color(0xFF2196F3),
        ),
        const Text('Recordarme', style: TextStyle(color: Colors.black87)),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _submit,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(
          0xFF2196F3,
        ), // Changed to use constant color
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        elevation: 8, // Añade sombra al botón
        shadowColor: Colors.blue.shade900,
      ),
      child:
          _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                'Iniciar sesión',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
    );
  }

  Widget _buildGoogleSignInButton() {
    return OutlinedButton.icon(
      onPressed: _signInWithGoogle,
      icon: Image.asset(
        'assets/icons/google_icon.png', // Make sure this path is correct
        height: 24.0,
      ),
      label: const Text('Continuar con Google'),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black87,
        side: const BorderSide(
          color: Colors.grey,
        ), // Changed to use default Colors
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "¿No tienes cuenta?",
          style: TextStyle(color: Colors.grey), // Changed to use default Colors
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RegisterScreen()),
            );
          },
          child: const Text(
            'Regístrate',
            style: TextStyle(
              color: Color(0xFF2196F3), // Changed to use constant color
              fontWeight: FontWeight.bold,
              decoration:
                  TextDecoration
                      .underline, // Añade subrayado al texto del botón
            ),
          ),
        ),
      ],
    );
  }
}
