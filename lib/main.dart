import 'package:flutter/material.dart';
import 'package:proj_comp_movel/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var colorScheme = ColorScheme.fromSeed(seedColor: Colors.blueAccent);
    return MaterialApp(
      title: 'Parques Emel',
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        appBarTheme: ThemeData.from(colorScheme: colorScheme).appBarTheme.copyWith(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.background,
        )
      ),
      home: MainPage(),
    );
  }
}

class PaginaParquesModoLista extends StatelessWidget {
  const PaginaParquesModoLista({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Parques Emel'),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildTextButton('Parque Vila Maria', '100m de distancia'),
            SizedBox(height: 20,),
            buildTextButton('Parque Combatentes', '500m de distancia'),
            SizedBox(height: 20,),
            buildTextButton('Parque Alvalade', '1km de distancia'),
          ],
        ),
      ),
    );
  }

  Widget buildTextButton(String nomeParque, String distancia){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 4),
      ),
      child: TextButton(onPressed: () {},
        style: TextButton.styleFrom(
          backgroundColor: Colors.grey,

        ),
        child: Column(
            children: <Widget>[
              Text(nomeParque, style: TextStyle(fontSize: 30, color: Colors.black)),
              Text(distancia, style: TextStyle(fontSize: 15, color: Colors.black)),
            ]
        ),),
    );
  }

}



