import 'package:flutter/material.dart';
import 'package:rush_app/Firebase/firebase_emulator.dart';
import 'package:rush_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/common/rusher_registration.dart';

// use 'firebase emulators:start' to start
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp( 
    options: DefaultFirebaseOptions.currentPlatform,
  );

  useEmulator();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      title: 'demo app',
      theme: ThemeData( 
        primarySwatch: Colors.green,
      ),

      home: const DynamicFormPage()
    );
  }
}

