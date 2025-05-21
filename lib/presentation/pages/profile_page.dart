import 'package:nexuserp/presentation/pages/changePasswordPage.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nexuserp/presentation/pages/login.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final supabase = Supabase.instance.client;
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('No user logged in.')));
    }

    final email = user.email ?? 'No email';
    final name = user.userMetadata?['name'] ?? 'No name';
    final imageUrl =
        user.userMetadata?['avatar_url'] ?? 'https://via.placeholder.com/150';

    return Scaffold(
      backgroundColor: const Color(0xF5F7FAFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Perfil',
                style: TextStyle(
                  fontSize: 32, // Increased font size for title
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A202C), // Darker title color
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  CircleAvatar(
                    radius: 40, // Increased avatar size
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  const SizedBox(width: 20), // Increased spacing
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 20, // Increased name size
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748), // Darker name color
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          email,
                          style: const TextStyle(
                            fontSize: 16, // Increased email size
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32), // Increased spacing
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Switch to Dark Mode',
                    style: TextStyle(fontSize: 16), // Increased font size
                  ),
                  Switch(
                    value: isDarkMode,
                    onChanged: (val) {
                      setState(() => isDarkMode = val);
                    },
                    activeColor: Colors.blue, // Changed active color
                  ),
                ],
              ),
              const SizedBox(height: 24), // Increased spacing
              const Divider(
                color: Color(0xFFE2E8F0), // Lighter divider color
                thickness: 1.5, // Increased thickness
              ),
              const SizedBox(height: 16), // Increased spacing
              const Text(
                'Configuración de la Cuenta',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20), // Increased spacing
              SettingTile(
                title: 'Cambiar Contraseña',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangePasswordPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16), // Increased spacing
              SettingTile(
                title: 'Editar Perfil',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfilePage()),
                  );
                },
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await supabase.auth.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Changed button color
                    foregroundColor: Colors.white, // Changed text color
                    elevation: 2, // Added elevation
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36, // Increased horizontal padding
                      vertical: 14, // Increased vertical padding
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        16,
                      ), // More rounded corners
                    ),
                    shadowColor: Colors.blue.withOpacity(
                      0.2,
                    ), // Add shadow color
                  ),
                  child: const Text(
                    'Cerrar Sesión',
                    style: TextStyle(fontSize: 18), // Increased font size
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SettingTile({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2, // Added elevation
      borderRadius: BorderRadius.circular(16), // More rounded corners
      shadowColor: Colors.grey.withOpacity(0.2), // Add shadow color
      child: InkWell(
        borderRadius: BorderRadius.circular(16), // More rounded corners
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ), // Increased padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF2D3748),
                ), // Increased font size, darker color
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 20, // Increased icon size
                color: Color(0xFFA0AEC0), // Lighter icon color
              ),
            ],
          ),
        ),
      ),
    );
  }
}
