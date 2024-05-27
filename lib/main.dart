import 'dart:math';

import 'package:flutter/material.dart';
import 'package:proj_comp_movel/http/http_client.dart';
import 'package:proj_comp_movel/main_page.dart';
import 'package:proj_comp_movel/pages.dart';
import 'package:provider/provider.dart';

import 'classes/Lote.dart';
import 'classes/Parque.dart';
import 'classes/ParquesRepository.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => ParquesRepository(client: HttpClient())),
        ChangeNotifierProvider(create: (_) => MainPageViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Lote> minhaListaParques = []; // Initialize an empty list

  @override
  void initState() {
    super.initState();
    // Fetch data in initState
    fetchData();
  }

  Future<void> fetchData() async {
    final parquesRepository = Provider.of<ParquesRepository>(context);
    minhaListaParques = await parquesRepository.getLots();
    // minhaListaParques.sort((a, b) => a.distancia.compareTo(b.distancia));
    setState(() {}); // Update state to trigger rebuild
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = ColorScheme.fromSeed(seedColor: Colors.blueAccent);

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
      home: MainPage(minhaListaParques: minhaListaParques), // Pass data to MainPage
    );
  }
}
