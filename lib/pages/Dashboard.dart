import 'package:flutter/material.dart';
import 'package:proj_comp_movel/pages.dart';

import '../classes/Parque.dart';
import 'DetalheParque.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  TextEditingController textEditingController = TextEditingController();

  var parques = minhaListaParques.parques;

  List<Parque> filterParques(String query) {
    // Filtrar os parques com base na query
    return minhaListaParques.parques.where((parque) {
      return parque.nome.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pages[0].title),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                controller: controller,
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0),
                ),
                onTap: () {
                  controller.openView();
                },
                onChanged: (_) {
                  controller.openView();
                },
                onSubmitted: (String value){
                  Parque parqueEncontrado = minhaListaParques.parques.firstWhere((parque) =>
                  parque.nome == value);
                  // Se o parque for encontrado, navega para a página de detalhes
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetalheParque(parque: parqueEncontrado)),
                  );
                                },
              );
            },
            suggestionsBuilder: (BuildContext context, SearchController controller) {
              String searchText = controller.text.toLowerCase();

              List<Parque> parquesFiltrados = minhaListaParques.parques.where((parque) {
                return parque.nome.toLowerCase().contains(searchText);
              }).toList();

              return List.generate(parquesFiltrados.length, (index) {
                return ListTile(
                  title: Text(parquesFiltrados[index].nome),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetalheParque(parque: parquesFiltrados[index])),
                    );
                  },
                );
              });
            },
          ),




          Text('map'),
          Text('3 parques proximos'),
        ],
      ),
    );
  }
}
