import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

// Iphone 15 simulator
// xcrun simctl boot 60382070-7787-4574-A898-672D761082C3
// flutter run -d 60382070-7787-4574-A898-672D761082C3

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const WelcomePage(),
    );
  }
}


class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});
  
  

  @override 
  WelcomePageState createState() => WelcomePageState();
}

class WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [AnimatedTextKit(
          animatedTexts: [
            WavyAnimatedText(
              'Welcome to RushMe',
              textStyle: const TextStyle (
                fontSize: 32.0,
                fontWeight: FontWeight.bold
                ),
              )
            ],
          ),


        ]
      )
    );
  }
}


// this is to just ensure everything is working correctly
class BlankPage extends StatelessWidget {
  const BlankPage({super.key});

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container()
    );
  }
}