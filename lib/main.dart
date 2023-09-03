import 'package:beatim5/screens/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'functions/get_or_generate_user_id.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  //　Firebaseの初期化
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // AppInitializerでの初期化処理
  await AppInitializer.initialize();

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

class AppInitializer {
  static Future<void> initialize() async {
    getOrGenerateUserId();
  }
}
