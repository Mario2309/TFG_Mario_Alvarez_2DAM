import 'package:nexuserp/presentation/pages/changePasswordPage.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nexuserp/presentation/pages/login.dart';
import 'edit_profile_page.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../core/utils/profile_page_strings.dart';

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
      return const Scaffold(
        body: Center(child: Text(ProfilePageStrings.noUser)),
      );
    }

    final email = user.email ?? ProfilePageStrings.noEmail;
    final name = user.userMetadata?['name'] ?? ProfilePageStrings.noName;
    final imageUrl =
        user.userMetadata?['avatar_url'] ?? 'https://via.placeholder.com/150';

    return Scaffold(
      backgroundColor: const Color(0xF5F7FAFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ListView(
            // Cambiado de Column a ListView para que todo sea desplazable y responsive
            children: [
              const Text(
                ProfilePageStrings.profile,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A202C),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          email,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    ProfilePageStrings.switchDarkMode,
                    style: TextStyle(fontSize: 16),
                  ),
                  Switch(
                    value: isDarkMode,
                    onChanged: (val) {
                      setState(() => isDarkMode = val);
                    },
                    activeColor: Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(color: Color(0xFFE2E8F0), thickness: 1.5),
              const SizedBox(height: 16),
              const Text(
                ProfilePageStrings.accountSettings,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              SettingTile(
                title: ProfilePageStrings.changePassword,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangePasswordPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              SettingTile(
                title: ProfilePageStrings.editProfile,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfilePage()),
                  );
                },
              ),
              const SizedBox(height: 16),
              SettingTile(
                title: 'Manual de usuario',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const _ManualPdfViewerPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
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
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shadowColor: Colors.blue.withOpacity(0.2),
                  ),
                  child: const Text(
                    ProfilePageStrings.logout,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 24),
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

class _ManualPdfViewerPage extends StatelessWidget {
  const _ManualPdfViewerPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manual de usuario')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final size = MediaQuery.of(context).size;
          double maxWidth = size.width * 0.95;
          double maxHeight = size.height * 0.85;
          double aspectRatio = size.width < 600 ? 3 / 4 : 4 / 5;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: maxWidth,
                    maxHeight: maxHeight,
                  ),
                  child: AspectRatio(
                    aspectRatio: aspectRatio,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: SfPdfViewer.asset(
                        'assets/manual/Manual_de_usuario.pdf',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
