import 'package:beatim5/screens/finish_run_page.dart';
import 'package:beatim5/screens/data_collect_agree_page.dart';
import 'package:beatim5/screens/earphones_recommend_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
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
      home: FinishRunPage(),
    );
  }
}
