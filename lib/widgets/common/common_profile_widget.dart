import 'package:flutter/material.dart';

class CommonProfileWidget extends StatefulWidget {
  const CommonProfileWidget({super.key});

  @override 
  CommonProfileWidgetState createState() => CommonProfileWidgetState();
}

class CommonProfileWidgetState extends State<CommonProfileWidget> { 

  @override  
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center( 
        child: Text("Profile Widget"),
      ) 
    );
  }
}