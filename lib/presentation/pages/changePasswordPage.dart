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

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await supabase.auth.updateUser(
          UserAttributes(password: _passwordController.text),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password updated successfully'),
            duration: Duration(seconds: 2), // Added duration for better UX
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
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
      fillColor: Colors.grey.shade50, // Lighter background color
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16), // More rounded corners
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Colors.blue.shade500,
        ), // More subtle focus color
      ),
      suffixIcon: IconButton(
        icon: Icon(
          controller.isObscured
              ? Icons.visibility_off_rounded
              : Icons.visibility_rounded, // Use rounded icons
          color: Colors.grey.shade500, // More subtle icon color
        ),
        onPressed: controller.toggleVisibility,
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 20,
      ), // Increased padding
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibilityController = Provider.of<PasswordVisibilityController>(
      context,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Cambiar Contraseña',
          style: TextStyle(
            color: Color(0xFF1A202C),
            fontWeight: FontWeight.w500,
          ), // Darker title color, medium weight
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Color(0xFF1A202C),
        ), // Darker icon color
        elevation: 0, // Removed app bar shadow
        centerTitle: true, // Center the title
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
                  'Secure your account',
                  style: TextStyle(
                    fontSize: 28, // Increased font size
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A202C), // Darker title color
                  ),
                ),
                const SizedBox(height: 12), // Increased spacing
                const Text(
                  'Enter your new password below to update it.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4A5568),
                  ), // Slightly larger font, darker grey
                ),
                const SizedBox(height: 40), // Increased spacing
                TextFormField(
                  controller: _passwordController,
                  obscureText: visibilityController.isObscured,
                  decoration: _inputDecoration(
                    'New Password',
                    visibilityController,
                  ),
                  validator: (value) {
                    if (value == null || value.length < 8) {
                      // Increased minimum password length to 8
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                  style: const TextStyle(fontSize: 16), // Increased font size
                ),
                const SizedBox(height: 24), // Increased spacing
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: visibilityController.isObscured,
                  decoration: _inputDecoration(
                    'Confirm Password',
                    visibilityController,
                  ),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  style: const TextStyle(fontSize: 16), // Increased font size
                ),
                const SizedBox(height: 48), // Increased spacing
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _changePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue.shade600, // Slightly darker blue
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                      ), // Increased vertical padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2, // Add elevation
                      shadowColor: Colors.blue.withOpacity(0.2), // Add shadow
                    ),
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3, // Increased stroke width
                            )
                            : const Text(
                              'Update Password',
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
