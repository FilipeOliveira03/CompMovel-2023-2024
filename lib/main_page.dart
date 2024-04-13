import 'package:flutter/material.dart';
import 'package:proj_comp_movel/pages.dart';

import 'pages/Dashboard.dart';

class MainPage extends StatefulWidget {
  MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white10,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          titleTextStyle: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: Scaffold(
        body: pages[_selectedIndex].widget,
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) => setState(() => _selectedIndex = index),
          destinations: pages.map((page) => NavigationDestination(icon: Icon(page.icon), label: page.title)).toList(),
        ),
      ),
    );
  }
}
