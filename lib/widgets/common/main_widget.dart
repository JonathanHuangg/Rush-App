import 'package:flutter/material.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override 
  MainWidgetState createState() => MainWidgetState();
}

class MainWidgetState extends State<MainWidget> { 

  @override  
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center( 
        child: Text("Main Page"),
      ) 
    );
  }
}