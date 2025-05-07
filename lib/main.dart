import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myapp/presentation/pages/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ayxlrgqpqkiouxqlnniv.supabase.co', // ← Reemplaza con tu URL de Supabase
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF5eGxyZ3FwcWtpb3V4cWxubml2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU0OTg0MjYsImV4cCI6MjA2MTA3NDQyNn0.jp2PkFj3cnJFSwoF-Bo3DIrM4IPbKw14pl2EY_GbOp0', // ← Reemplaza con tu anonKey
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NexusERP',
      home: LoginScreen(),
    );
  }
}
