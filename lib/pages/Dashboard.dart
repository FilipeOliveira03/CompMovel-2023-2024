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
      appBar: AppBar(
        title: Text(pages[0].title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 15,),
            SearchBarApp(),
            Text('map'),
            Text('3 parques proximos'),
          ]
        ),
      ),
    );
  }
}


class SearchBarApp extends StatefulWidget {
  const SearchBarApp({super.key});

  @override
  State<SearchBarApp> createState() => _SearchBarAppState();
}

class _SearchBarAppState extends State<SearchBarApp> {
  List<Parque> historico = <Parque>[];

  Iterable<Widget> getListaHistorico(SearchController controller) {
    return historico.map(
      (Parque parque) => ListTile(
        leading: const Icon(Icons.history),
        title: Text(parque.nome),
        trailing: IconButton(
          icon: const Icon(Icons.call_missed),
          onPressed: () {
            controller.text = parque.nome;
            controller.selection =
                TextSelection.collapsed(offset: controller.text.length);
          },
        ),
      ),
    );
  }

  Iterable<Widget> getSugestoes(SearchController controller) {
    final String input = controller.value.text;
    return minhaListaParques.parques
        .where((Parque parque) => parque.nome.contains(input))
        .map(
          (Parque parque) => ListTile(
            title: Text(parque.nome),
            trailing: IconButton(
              icon: const Icon(Icons.call_missed),
              onPressed: () {
                controller.text = parque.nome;
                controller.selection =
                    TextSelection.collapsed(offset: controller.text.length);
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetalheParque(parque: parque)),
              );
              mudaHistorico(parque);
            },
          ),
        );
  }

  void mudaHistorico(Parque parque) {
    setState(() {
      if (historico.length >= 5) {
        historico.removeLast();
      }
      historico.insert(0, parque);
    });
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
        height: 40,
        width: 370,
        child: SearchAnchor.bar(
          barHintText: 'Procura parques',
          onSubmitted: (String value){

            bool existe = false;
            var parqueEncontrado;

            for(var i = 0; i < minhaListaParques.parques.length; i++){
              if(minhaListaParques.parques[i].nome == value){
                existe = true;
                parqueEncontrado = minhaListaParques.parques[i];
              }
            }

            if(existe){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetalheParque(parque: parqueEncontrado)),
              );
            }
          },
          suggestionsBuilder:
              (BuildContext context, SearchController controller) {
            if (controller.text.isEmpty) {
              if (historico.isNotEmpty) {
                return getListaHistorico(controller);
              }
              return <Widget>[
                Center(
                    child: Column(
                      children: [
                        SizedBox(height: 5,),
                        Text('Não têm pesquisas recentes',)
                      ],
                    ))
              ];
            }
            return getSugestoes(controller);
          },
        )
    ) ;
  }
}
