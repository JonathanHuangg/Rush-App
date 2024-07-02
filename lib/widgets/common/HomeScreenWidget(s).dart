import 'package:flutter/material.dart';
import 'package:rush_app/widgets/common/detail_page.dart';
class HomePageWidget extends StatefulWidget {
  @override 
  HomePageWidgetState createState() => HomePageWidgetState();
}

class HomePageWidgetState extends State<HomePageWidget> {

  // controls the text in the seasrchbar
  TextEditingController _searchController = TextEditingController();
  
  // this must be changed later to read from firebase and turn into a list
  List<String> _allData = ["Bob", "James", "Jones", "Quincy", "Harry", "Levy"];
  List<String> _filteredData = [];

  // called in the beginning when state is created
  @override 
  void initState() {
    super.initState();
    _filteredData = _allData;
  }

  void _filterData(String query) {
    setState(() { 
      _filteredData = _allData
        .where((element) => element.toLowerCase().contains(query.toLowerCase()))
        .toList();
    });
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [ 
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField( 
              controller: _searchController,
              decoration: InputDecoration( 
                hintText: "Search...",
                border: OutlineInputBorder( 
                  borderRadius: BorderRadius.circular(8.0)
                ),
                prefixIcon: const Icon(Icons.search)
              ),
              onChanged: (query) => _filterData(query),
            )
          ),

          Expanded(
            child: ListView.builder( 
              itemCount: _filteredData.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () { 
                    Navigator.push( 
                      context, 
                      MaterialPageRoute( 
                        builder: (context) => DetailPage(name: _filteredData[index])
                      )
                    );
                  },
                  child: ListTile(
                    title: Text(_filteredData[index])
                  )
                );
              }
            )
          )

        ]
      )
    );

  }
}