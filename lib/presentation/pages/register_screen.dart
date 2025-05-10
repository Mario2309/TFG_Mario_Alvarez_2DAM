import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nexuserp/presentation/pages/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nexuserp/core/utils/password_visibility_controller.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PasswordVisibilityController()),
        ChangeNotifierProvider(create: (_) => PasswordVisibilityController()),
      ],
      child: const RegisterForm(),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;

  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        data: {
          'name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
        },
      );

      if (response.user != null) {
        await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text('Registro exitoso'),
                content: Text(
                  'Tu cuenta ha sido creada. Revisa tu correo para verificar tu cuenta.',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
        );
      } else {
        setState(() {
          _error = "El registro falló. Inténtalo de nuevo.";
        });
      }
    } on AuthException catch (e) {
      setState(() {
        _error = e.message;
      });
    } catch (e) {
      setState(() {
        _error = 'Ocurrió un error inesperado. Inténtalo de nuevo.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final passwordVisibility = Provider.of<PasswordVisibilityController>(
      context,
      listen: true,
    );
    final confirmVisibility = Provider.of<PasswordVisibilityController>(
      context,
      listen: false,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Container(
            padding: EdgeInsets.all(24.0),
            constraints: BoxConstraints(maxWidth: 500),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
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
                Column(
                  children: [
                    SizedBox(height: 20.0),
                    Text(
                      'Crea tu cuenta en NexusERP',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Completa los campos para registrarte',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
                SizedBox(height: 24.0),
                if (_error != null) ...[
                  Text(
                    _error!,
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12.0),
                ],
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person_outline),
                          labelText: 'Nombre completo',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          contentPadding: EdgeInsets.all(16.0),
                        ),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Por favor ingresa tu nombre'
                                    : null,
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone),
                          labelText: 'Número de teléfono',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          contentPadding: EdgeInsets.all(16.0),
                        ),
                        keyboardType: TextInputType.phone,
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Por favor ingresa tu teléfono'
                                    : null,
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined),
                          labelText: 'Correo electrónico',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          contentPadding: EdgeInsets.all(16.0),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Por favor ingresa tu correo';
                          if (!value.contains('@')) return 'Correo inválido';
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      Consumer<PasswordVisibilityController>(
                        builder:
                            (_, visibility, __) => TextFormField(
                              controller: _passwordController,
                              obscureText: visibility.isObscured,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock_outline),
                                labelText: 'Contraseña',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                contentPadding: EdgeInsets.all(16.0),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    visibility.isObscured
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: visibility.toggleVisibility,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Por favor ingresa tu contraseña';
                                if (value.length < 6)
                                  return 'Debe tener al menos 6 caracteres';
                                return null;
                              },
                            ),
                      ),
                      SizedBox(height: 16.0),
                      Consumer<PasswordVisibilityController>(
                        builder:
                            (_, visibility, __) => TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: confirmVisibility.isObscured,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock_outline),
                                labelText: 'Confirmar contraseña',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                contentPadding: EdgeInsets.all(16.0),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    confirmVisibility.isObscured
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: confirmVisibility.toggleVisibility,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Confirma tu contraseña';
                                if (value != _passwordController.text)
                                  return 'Las contraseñas no coinciden';
                                return null;
                              },
                            ),
                      ),
                      SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          padding: EdgeInsets.symmetric(vertical: 14.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child:
                            _isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                  'Registrar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 28.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "¿Ya tienes cuenta?",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Inicia sesión',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}