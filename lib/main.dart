import 'package:chatappfirebase/services/Auth/auth_gate.dart';
import 'package:chatappfirebase/firebase_options.dart';
import 'package:chatappfirebase/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat app',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const AuthGate(),
      debugShowCheckedModeBanner: false,
    );
  }
}
