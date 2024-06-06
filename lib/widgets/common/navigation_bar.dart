import 'package:flutter/material.dart';

// container that manages state of child widget: BottomNavigationBar
class NavigationBar extends StatefulWidget {
  final Function(int) onTabTapped;
  final int currentIndex;
  final List<NavigationBarItem> items;

  NavigationBar({
    required this.onTabTapped,
    required this.currentIndex,
    required this.items,
  });

  @override
  NavigationBarState createState() => NavigationBarState();

}

class NavigationBarState extends State<NavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar( 
      onTap: widget.onTabTapped,
      currentIndex: widget.currentIndex,
      items: widget.items.map((item) {
        return BottomNavigationBarItem(icon: item.icon, label: item.label);
      }).toList(),
    );
  }
}

class NavigationBarItem {
  final Widget icon;
  final String label;

  NavigationBarItem ({
    required this.icon, 
    required this.label
  });
}