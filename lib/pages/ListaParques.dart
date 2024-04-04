import 'package:flutter/material.dart';
import 'package:proj_comp_movel/classes/ListParques.dart';
import 'package:proj_comp_movel/pages/DetalheParque.dart';

import '../classes/Parque.dart';
import '../pages.dart';

class ListaParques extends StatefulWidget {
  const ListaParques({super.key});

  @override
  State<ListaParques> createState() => _ListaParquesState();
}

class _ListaParquesState extends State<ListaParques> {
  @override
  Widget build(BuildContext context) {

    var listaParques = minhaListaParques;

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Parques'),
      ),
      body: ListView.builder(
        itemCount: listaParques.parques.length,
        itemBuilder: (context, index) {
          Parque? parque = listaParques.parques[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(parque.nome),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Lugares ocupados: ${parque.lotAtual}'),
                  Text('Capacidade máxima: ${parque.lotMaxima}'),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetalheParque(parque: parque)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
