import 'package:beatim5/screens/welcome_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
      const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beatim',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: WelcomePage(),
    );
  }
}
