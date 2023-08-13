import 'package:beatim5/screens/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Beatim',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      // darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: WelcomePage(),
    );
  }
}
