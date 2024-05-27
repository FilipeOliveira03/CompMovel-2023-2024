import 'package:flutter/material.dart';
import 'package:proj_comp_movel/classes/Parque.dart';
import 'package:proj_comp_movel/pages.dart';
import 'package:provider/provider.dart';

import 'classes/Lote.dart';
import 'pages/Dashboard.dart';

class MainPageViewModel extends ChangeNotifier{
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value){
    _selectedIndex = value;
    notifyListeners();
  }
}

class MainPage extends StatefulWidget {
  MainPage({super.key, required List<Lote> minhaListaParques});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {

    final viewModel = context.watch<MainPageViewModel>();

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
        body: pages[viewModel.selectedIndex].widget,
        bottomNavigationBar: NavigationBar(
          selectedIndex: viewModel.selectedIndex,
          onDestinationSelected: (index) => viewModel.selectedIndex = index,
          destinations: pages.map((page) => NavigationDestination(icon: Icon(page.icon), label: page.title)).toList(),
        ),
      ),
    );
  }
}
