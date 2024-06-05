import 'dart:math';

import 'package:flutter/material.dart';
import 'package:proj_comp_movel/data/parquesDatabase.dart';
import 'package:proj_comp_movel/http/http_client.dart';
import 'package:proj_comp_movel/main_page.dart';
import 'package:proj_comp_movel/repository/ParquesRepository.dart';
import 'package:proj_comp_movel/services/connectivity_service.dart';
import 'package:provider/provider.dart';

import 'classes/Lote.dart';
import 'data/ParquesService.dart';
import 'data/parquesDatabase.dart';

void main() {
  final parqueService = ParquesServices(client: HttpClient());
  final parqueDatabase = ParquesDatabase();

  runApp(
    MultiProvider(
      providers: [
        Provider<ParquesServices>(create: (_) => parqueService),
        Provider<ParquesDatabase>(create: (_) => parqueDatabase),
        Provider<ParquesRepository>(create: (_) => ParquesRepository(local: parqueDatabase, remote: parqueService, connectivityService: ConnectivityService())),
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
    final parquesRepository = Provider.of<ParquesServices>(context);
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
          if (snapshot.connectionState == ConnectionState.done) {
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
                  minhaListaParques:
                      minhaListaParques), // Pass data to MainPage
            );
          } else {
            return MaterialApp(
              home: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
