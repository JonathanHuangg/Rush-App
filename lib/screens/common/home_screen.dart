import 'package:flutter/material.dart';
import 'package:rush_app/widgets/common/HomeScreenWidget(s).dart';
/*

This page will hold the place where you can see all of the members

*/

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  
  // The following is for UI purposes. Need to delete later


  @override 
  Widget build(BuildContext context) {
    return Scaffold( 
      body: HomePageWidget()
    );
  }
}