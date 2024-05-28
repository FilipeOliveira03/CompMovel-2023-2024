import 'dart:math';

import 'package:flutter/material.dart';
import 'package:proj_comp_movel/data/parquesDatabase.dart';
import 'package:proj_comp_movel/http/http_client.dart';
import 'package:proj_comp_movel/main_page.dart';
import 'package:provider/provider.dart';

import 'classes/Lote.dart';
import 'classes/ParquesRepository.dart';
import 'data/parquesDatabase.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<ParquesRepository>(
            create: (_) => ParquesRepository(client: HttpClient())),
        Provider<ParquesDatabase>(create: (_) => ParquesDatabase()),
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

    final parquesDatabase = context.read<ParquesDatabase>();

    return FutureBuilder(
        future: parquesDatabase.init(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done){
            return MaterialApp(
              title: 'Parques Emel',
              theme: ThemeData(
                  colorScheme: colorScheme,
                  useMaterial3: true,
                  appBarTheme: ThemeData.from(colorScheme: colorScheme)
                      .appBarTheme
                      .copyWith(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.background,
                  )),
              home: MainPage(
                  minhaListaParques: minhaListaParques), // Pass data to MainPage
            );
          }else{
            return MaterialApp(
              home: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

        });
  }
}
