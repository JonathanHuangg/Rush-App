/*

This page is for the profile for each of the PNMs. This can grab the name. Make the search 
through the database for the rest of the information such as summary, image, etc. 

*/

import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final String name;
  DetailPage({required this.name});

  DetailPageState createState() => DetailPageState();
}

class DetailPageState extends State<DetailPage> {


  @override 
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar( 
        title: Text(widget.name)
      ),

      body: Center( 
        child: Text("details for ${widget.name}")
      )
    );
  }
}