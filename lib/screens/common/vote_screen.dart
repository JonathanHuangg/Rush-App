import 'package:flutter/material.dart';

/*

This page will hold the place where you put the votes

*/

class MyVotesScreen extends StatefulWidget {
  const MyVotesScreen({super.key});

  @override
  MyVotesScreenState createState() => MyVotesScreenState();
}

class MyVotesScreenState extends State<MyVotesScreen> {
  

  @override 
  Widget build(BuildContext context) {
    return Scaffold( 
      body: const Center( 
        child: Text("Vote Screen")
      )
    );
  }
}