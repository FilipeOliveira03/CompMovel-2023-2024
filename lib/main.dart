import 'dart:math';

import 'package:flutter/material.dart';
import 'package:proj_comp_movel/main_page.dart';
import 'package:proj_comp_movel/pages.dart';
import 'package:provider/provider.dart';

import 'classes/ParquesRepository.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => ParquesRepository()),
        ChangeNotifierProvider(create: (_) => MainPageViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = ColorScheme.fromSeed(seedColor: Colors.blueAccent);
    final minhaListaParques = context.read<ParquesRepository>().getParques();
    minhaListaParques
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
