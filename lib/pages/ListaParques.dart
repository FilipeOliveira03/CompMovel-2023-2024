import 'package:flutter/material.dart';
import 'package:proj_comp_movel/classes/ListParques.dart';

import '../classes/Parque.dart';
import '../pages.dart'; // Importe a classe ListParques aqui

class ListaParques extends StatelessWidget {
  final ListParques listaParques;

  const ListaParques({Key? key, required this.listaParques}) : super(key: key); // Adicione o parâmetro listaParques aqui

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Parques'),
      ),
      body: ListView.builder(
        itemCount: listaParques.parques.length, // Acessa a lista de parques de listaParques
        itemBuilder: (context, index) {
          Parque parque = listaParques.parques[index]; // Acessa cada parque da lista
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
                  MaterialPageRoute(builder: (context) => pageParque[0].widget),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
