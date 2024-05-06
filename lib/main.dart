import 'dart:math';

import 'package:flutter/material.dart';
import 'package:proj_comp_movel/main_page.dart';
import 'package:proj_comp_movel/pages.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (BuildContext context) => MainPageViewModel(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = ColorScheme.fromSeed(seedColor: Colors.blueAccent);

    minhaListaParques.parques
        .sort((a, b) => a.distancia.compareTo(b.distancia));

    return MaterialApp(
      title: 'Parques Emel',
      theme: ThemeData(
          colorScheme: colorScheme,
          useMaterial3: true,
          appBarTheme:
              ThemeData.from(colorScheme: colorScheme).appBarTheme.copyWith(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.background,
                  )),
      home: MainPage(),
    );
  }
}
