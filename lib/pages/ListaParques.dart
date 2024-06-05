import 'package:flutter/material.dart';
import 'package:proj_comp_movel/data/parquesDatabase.dart';
import 'package:proj_comp_movel/pages/DetalheParque.dart';
import 'package:provider/provider.dart';
import '../classes/Lote.dart';
import '../classes/Parque.dart';
import '../data/ParquesService.dart';
import '../pages.dart';
import '../repository/ParquesRepository.dart';

class ListaParques extends StatefulWidget {
  const ListaParques({Key? key}) : super(key: key);

  @override
  State<ListaParques> createState() => _ListaParquesState();
}

class _ListaParquesState extends State<ListaParques> {
  bool ordenarPorDistanciaCrescente = true;


  @override
  void initState() {
    super.initState();
  }

  void ordenarParquesPorDistancia() {
    // setState(() {
    //   listaParques.sort((a, b) => b.distancia.compareTo(a.distancia));
    //   ordenarPorDistanciaCrescente = !ordenarPorDistanciaCrescente;
    //   if (ordenarPorDistanciaCrescente) {
    //     listaParques.sort((a, b) => a.distancia.compareTo(b.distancia));
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {

    final parquesRepository = context.read<ParquesRepository>();

    return FutureBuilder(
        future: parquesRepository.getLots(),
        builder: (_, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError) {
              return Center(child: Text('Error'),);
            } else {
              return buildLista(snapshot.data!);
            }
          }
    });

  }

  Scaffold buildLista(listaLot) {
    var listaLots = List<Lote>.from(listaLot);
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Parques'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 15),
            SearchBarApp(),
            SizedBox(height: 5),
            Divider(
              height: 20,
              thickness: 2,
              color: Colors.grey,
              indent: 20,
              endIndent: 20,
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(bottom: 60),
                itemCount: listaLots.length,
                itemBuilder: (context, index) {
                  Lote lote = listaLots[index];

                  var lotOcupacao = lote.lotAtual;

                  if (lotOcupacao < 0) {
                    lotOcupacao = lote.lotMaxima;
                  }

                  var lotAtual = lote.lotMaxima - lotOcupacao;

                  var corLotacao;
                  if (lotAtual == 0) {
                    corLotacao = Colors.red;
                  } else if (lotAtual < (lote.lotMaxima * 0.1).toInt()) {
                    corLotacao = Colors.amber;
                  } else {
                    corLotacao = Colors.green;
                  }

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalheParque(lote: lote),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                                    label: lote.nome,
                                    tamanho: 18,
                                    cor: Colors.black,
                                    font: FontWeight.bold,
                                  ),
                                  // textoParqProx(
                                  //   label: lote.distancia.toString(),
                                  //   tamanho: 20,
                                  //   cor: Colors.black,
                                  //   font: FontWeight.bold,
                                  // ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  textoParqProx(
                                    label: lote.tipoParque,
                                    tamanho: 14,
                                    cor: Colors.black54,
                                    font: FontWeight.normal,
                                  ),
                                  textoParqProx(
                                    label: '${lotAtual} Lugares Vazios!',
                                    tamanho: 14,
                                    cor: corLotacao,
                                    font: FontWeight.bold,
                                  ),
                                  textoParqProx(
                                    label: 'm de si',
                                    tamanho: 14,
                                    cor: Colors.black54,
                                    font: FontWeight.normal,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(
              height: 15,
              thickness: 2,
              color: Colors.grey,
              indent: 20,
              endIndent: 20,
            ),
            ElevatedButton.icon(
              onPressed: ordenarParquesPorDistancia,
              icon: Icon(ordenarPorDistanciaCrescente
                  ? Icons.arrow_upward
                  : Icons.arrow_downward),
              label: Text(
                  'Ordenar por Distância ${ordenarPorDistanciaCrescente ? 'decrescente' : 'crescente'}'),
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}

class textoParqProx extends StatelessWidget {
  const textoParqProx({
    Key? key,
    required this.label,
    required this.tamanho,
    required this.cor,
    required this.font,
  }) : super(key: key);

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
  const SearchBarApp({Key? key}) : super(key: key);

  @override
  State<SearchBarApp> createState() => _SearchBarAppState();
}

class _SearchBarAppState extends State<SearchBarApp> {
  List<Lote> historico = <Lote>[];
  List<Lote> minhaListaParques = [];

  @override
  void initState() {
    super.initState();
    _carregarParques();
  }

  Future<void> _carregarParques() async {
    final lista = await context.read<ParquesServices>().getLots();
    setState(() {
      minhaListaParques = lista;
    });
  }

  Iterable<Widget> getListaHistorico(SearchController controller) {
    return historico.map(
      (Lote lote) => ListTile(
        leading: const Icon(Icons.history),
        title: Text(lote.nome),
        trailing: IconButton(
          icon: const Icon(Icons.call_missed),
          onPressed: () {
            controller.text = lote.nome;
            controller.selection =
                TextSelection.collapsed(offset: controller.text.length);
          },
        ),
      ),
    );
  }

  Iterable<Widget> getSugestoes(SearchController controller) {
    final String input = controller.value.text;
    return minhaListaParques
        .where((Lote lote) => lote.nome.contains(input))
        .map(
          (Lote lote) => ListTile(
            title: Text(lote.nome),
            trailing: IconButton(
              icon: const Icon(Icons.call_missed),
              onPressed: () {
                controller.text = lote.nome;
                controller.selection =
                    TextSelection.collapsed(offset: controller.text.length);
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetalheParque(lote: lote)),
              );
              mudaHistorico(lote);
            },
          ),
        );
  }

  void mudaHistorico(Lote lote) {
    setState(() {
      if (historico.length >= 5) {
        historico.removeLast();
      }
      historico.insert(0, lote);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: MediaQuery.of(context).size.width * 0.9,
      child: SearchAnchor.bar(
        barHintText: 'Procura parques',
        onSubmitted: (String value) {
          bool existe = false;
          late Lote parqueEncontrado;

          for (var lote in minhaListaParques) {
            if (lote.nome == value) {
              existe = true;
              parqueEncontrado = lote;
              break;
            }
          }

          if (existe) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetalheParque(lote: parqueEncontrado)),
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
                    SizedBox(height: 5),
                    Text('Não têm pesquisas recentes'),
                  ],
                ),
              ),
            ];
          }
          return getSugestoes(controller);
        },
      ),
    );
  }
}
