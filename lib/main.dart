import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'rusherRegistration.dart';

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

class WelcomePageState extends State<WelcomePage> with SingleTickerProviderStateMixin {

  double _buttonOpacity = 0.0;

  @override
  void initState() {
    super.initState();

    // this will start the fade in for the start button

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _buttonOpacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [AnimatedTextKit(
          animatedTexts: [
            WavyAnimatedText(
              'Welcome to RushMe',
              textStyle: const TextStyle (
                fontSize: 32.0,
                fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),

          const SizedBox(height: 20.0),
          AnimatedOpacity(
            opacity: _buttonOpacity, 
            duration: const Duration(seconds: 1),
            child: ElevatedButton(
              onPressed: () {
                // Leads you to the next screen
              },
              child: const Text('Start')
            )
          )
        ]
      ))
      
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