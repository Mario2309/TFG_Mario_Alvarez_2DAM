import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nexuserp/presentation/pages/register_screen.dart';
import 'package:nexuserp/presentation/pages/main_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nexuserp/core/utils/password_visibility_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:another_flushbar/flushbar.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:nexuserp/features/employee/domain/entities/employee.dart';
import 'package:nexuserp/features/employee/presentation/pages/employee_simple_options_page.dart';
import '../../core/utils/login_screen_strings.dart';

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
      _showErrorSnackbar(context, LoginScreenStrings.googleNotImplemented);
    } catch (e) {
      _showErrorSnackbar(context, LoginScreenStrings.googleFailed);
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
              LoginScreenStrings.welcome,
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
          LoginScreenStrings.loginToContinue,
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

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email_outlined),
        labelText: LoginScreenStrings.email,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        contentPadding: const EdgeInsets.all(16.0),
      ),
      keyboardType: TextInputType.emailAddress,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null) return null;
        if (value.isNotEmpty && !value.contains('@')) {
          return LoginScreenStrings.invalidEmail;
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
        labelText: LoginScreenStrings.password,
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
          return LoginScreenStrings.enterPassword;
        }
        if (value.length < 6) {
          return LoginScreenStrings.passwordMinLength;
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
        const Text(
          LoginScreenStrings.rememberMe,
          style: TextStyle(color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _submit,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2196F3),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        elevation: 8,
        shadowColor: Colors.blue.shade900,
      ),
      child:
          _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                LoginScreenStrings.login,
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
    );
  }

  Widget _buildGoogleSignInButton() {
    return OutlinedButton.icon(
      onPressed: _signInWithGoogle,
      icon: Image.asset('assets/icons/google_icon.png', height: 24.0),
      label: const Text(LoginScreenStrings.continueWithGoogle),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black87,
        side: const BorderSide(color: Colors.grey),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
      ),
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
            label: Text(
              _isEmployeeLogin
                  ? LoginScreenStrings.employee
                  : LoginScreenStrings.admin,
            ),
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

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          LoginScreenStrings.noAccount,
          style: TextStyle(color: Colors.grey),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RegisterScreen()),
            );
          },
          child: const Text(
            LoginScreenStrings.register,
            style: TextStyle(
              color: Color(0xFF2196F3),
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
