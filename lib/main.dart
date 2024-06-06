import 'package:flutter/material.dart';

import 'screens/common/rusher_registration.dart';

void main() {
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

