import 'package:flutter/material.dart';
import 'package:rush_app/screens/common/home_screen.dart';
import 'package:rush_app/widgets/common/navigation_bar.dart';
import 'package:rush_app/screens/common/vote_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override 
  MainScreenState createState() => MainScreenState(); 
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? "Home" : "My Votes"),
      ),
      body: IndexedStack(
        index: _selectedIndex, 
        children: const [ 
          HomeScreen(), 
          MyVotesScreen(),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        onTabTapped: _onTabTapped,
        currentIndex: _selectedIndex,
        items: [
          NavigationBarItem(icon: const Icon(Icons.home), label: "Home"),
          NavigationBarItem(icon: const Icon(Icons.search), label: "My Votes"),
        ],
      ),
    );
  }
}
