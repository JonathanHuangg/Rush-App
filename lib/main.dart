import 'package:flutter/material.dart';
import 'package:rush_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rush_app/screens/common/welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/common/rusher_registration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Uncomment this if you want to use the Firebase emulator
    // useEmulator();

    // this checks if the app is opened for the first time
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      await prefs.setBool('isFirstTime', false);
    }

    runApp(MyApp(isFirstTime: isFirstTime));
  } catch (e) {
    // Handle initialization error
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text("Failed to initialize Firebase: $e"),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;
  const MyApp({super.key, required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'demo app',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: isFirstTime ? const WelcomePage() : const DynamicFormPage(),
    );
  }
}
