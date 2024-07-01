import 'package:flutter/material.dart';

/*

This page will hold the place where you put the votes

*/

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  

  @override 
  Widget build(BuildContext context) {
    return Scaffold( 
      body: const Center( 
        child: Text("Home Screen")
      )
    );
  }
}