import 'package:flutter/material.dart' as mat;
import 'package:rush_app/widgets/common/navigation_bar.dart' as custom;
import 'package:rush_app/widgets/common/main_widget.dart';
import 'package:rush_app/widgets/common/common_profile_widget.dart';

class RusherMainPage extends mat.StatefulWidget {
  const RusherMainPage({super.key});

  @override
  RusherMainPageState createState() => RusherMainPageState();
}

class RusherMainPageState extends mat.State<RusherMainPage> {
  int _currentIndex = 0;

  final List<custom.NavigationBarItem> _navItems = [
    custom.NavigationBarItem(icon: const mat.Icon(mat.Icons.home), label: "Main"),
    custom.NavigationBarItem(icon: const mat.Icon(mat.Icons.home), label: "My Votes"),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  mat.Widget build(mat.BuildContext context) {
    return mat.Scaffold(
      body: mat.Column(
        children: [
          mat.Expanded(
            child: mat.Center(
              child: _getCurrentPage(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: custom.NavigationBar(
        onTabTapped: _onTabTapped,
        currentIndex: _currentIndex,
        items: _navItems,
      ),
    );
  }

  mat.Widget _getCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return MainWidget();
      case 1:
        return CommonProfileWidget();
      default:
        return MainWidget();
    }
  }
}

