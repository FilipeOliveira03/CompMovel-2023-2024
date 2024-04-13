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
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              SearchBarApp(),
              SizedBox(
                height: 5,
              ),
              Divider(
                height: 20,
                thickness: 2,
                color: Colors.grey,
                indent: 20,
                endIndent: 20,
              ),
              Container(
                height: 490,
                width: 500,
                child: ListView.builder(
                  itemCount: listaParques.parques.length,
                  itemBuilder: (context, index) {
                    var lista = List<Parque>.from(minhaListaParques.parques);
                    lista.sort((a, b) => a.distancia.compareTo(b.distancia));
                    Parque parque = lista[index];

                    var lotAtual = parque.lotMaxima - parque.lotAtual;
                    var corLotacao;
                    if (lotAtual == 0) {
                      corLotacao = Colors.red;
                    } else if (lotAtual < (parque.lotMaxima * 0.1).toInt()) {
                      corLotacao = Colors.amber;
                    } else {
                      corLotacao = Colors.green;
                    }

                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetalheParque(parque: parque)),
                          );
                        },
                        child: Container(
                          margin:
                              EdgeInsets.only(bottom: 10, right: 15, left: 15),
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      textoParqProx(
                                          label: parque.nome,
                                          tamanho: 18,
                                          cor: Colors.black,
                                          font: FontWeight.bold),
                                      textoParqProx(
                                          label: parque.distancia.toString(),
                                          tamanho: 20,
                                          cor: Colors.black,
                                          font: FontWeight.bold),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      textoParqProx(
                                          label:
                                              '${parque.preco.toStringAsFixed(2)}€/hr',
                                          tamanho: 14,
                                          cor: Colors.black54,
                                          font: FontWeight.normal),
                                      textoParqProx(
                                          label:
                                              '${parque.lotMaxima - parque.lotAtual} Lugares Vazios!',
                                          tamanho: 14,
                                          cor: corLotacao,
                                          font: FontWeight.bold),
                                      textoParqProx(
                                          label: 'm de si',
                                          tamanho: 14,
                                          cor: Colors.black54,
                                          font: FontWeight.normal),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ));
                  },
                ),
              ),
            ],
          ),
        ));
  }
}

class textoParqProx extends StatelessWidget {
  const textoParqProx({
    super.key,
    required this.label,
    required this.tamanho,
    required this.cor,
    required this.font,
  });

  final String label;
  final double? tamanho;
  final Color cor;
  final FontWeight font;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: tamanho,
        color: cor,
        fontWeight: font,
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
                MaterialPageRoute(
                    builder: (context) => DetalheParque(parque: parque)),
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
        height: 45,
        width: 365,
        child: SearchAnchor.bar(
          barHintText: 'Procura parques',
          onSubmitted: (String value) {
            bool existe = false;
            var parqueEncontrado;

            for (var i = 0; i < minhaListaParques.parques.length; i++) {
              if (minhaListaParques.parques[i].nome == value) {
                existe = true;
                parqueEncontrado = minhaListaParques.parques[i];
              }
            }

            if (existe) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DetalheParque(parque: parqueEncontrado)),
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
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Não têm pesquisas recentes',
                    )
                  ],
                ))
              ];
            }
            return getSugestoes(controller);
          },
        ));
  }
}
