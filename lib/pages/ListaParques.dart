import 'package:flutter/material.dart';
import 'package:proj_comp_movel/pages/DetalheParque.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../classes/Lote.dart';
import '../data/ParquesService.dart';
import '../repository/ParquesRepository.dart';

class ListaParques extends StatefulWidget {
  const ListaParques({Key? key}) : super(key: key);

  @override
  State<ListaParques> createState() => _ListaParquesState();
}

class _ListaParquesState extends State<ListaParques> {
  bool ordenarPorDistanciaCrescente = true;
  Position? userLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    userLocation = await Geolocator.getCurrentPosition();
    setState(() {});
  }

  Future<List<Lote>> _fetchAndSortParques(
      ParquesRepository parquesRepository) async {
    var listaParques = await parquesRepository.getLots();
    if (userLocation != null) {
      for (var parque in listaParques) {
        parque.distancia = Geolocator.distanceBetween(
          userLocation!.latitude,
          userLocation!.longitude,
          double.parse(parque.latitude),
          double.parse(parque.longitude),
        );
      }
      listaParques.sort((a, b) => a.distancia!.compareTo(b.distancia!));
    }
    if (!ordenarPorDistanciaCrescente) {
      listaParques = listaParques.reversed.toList();
    }
    return listaParques;
  }

  @override
  Widget build(BuildContext context) {
    final parquesRepository = context.read<ParquesRepository>();

    return FutureBuilder(
        future: _fetchAndSortParques(parquesRepository),
        builder: (_, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error'),
              );
            } else {
              var listaParques = List<Lote>.from(snapshot.data!);
              return buildLista(listaParques);
            }
          }
        });
  }

  Scaffold buildLista(List<Lote> listaLots) {
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
                  var lotMaxima = lote.lotMaxima;

                  if (lotOcupacao < 0) {
                    lotOcupacao = lote.lotMaxima;
                  }

                  if (lotMaxima <= 0) {
                    lotMaxima = lotOcupacao;
                  }

                  if(lote.lotAtual > lote.lotMaxima){
                    lotOcupacao = lote.lotMaxima;
                  }

                  var lotAtual = lotMaxima - lotOcupacao;

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
                                  lote.distancia != null
                                      ? lote.distancia! >= 1000
                                          ? textoParqProx(
                                              label: (lote.distancia! / 1000)
                                                  .toStringAsFixed(1),
                                              tamanho: 18,
                                              cor: Colors.black,
                                              font: FontWeight.bold,
                                            )
                                          : textoParqProx(
                                              label:
                                                  '${lote.distancia?.toStringAsFixed(0)}',
                                              tamanho: 18,
                                              cor: Colors.black,
                                              font: FontWeight.bold,
                                            )
                                      : textoParqProx(
                                          label: 'Indisponível',
                                          tamanho: 15,
                                          cor: Colors.black,
                                          font: FontWeight.normal,
                                        )
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
                                  lote.distancia != null &&
                                          lote.distancia! >= 1000
                                      ? textoParqProx(
                                          label: 'Km de si',
                                          tamanho: 14,
                                          cor: Colors.black54,
                                          font: FontWeight.normal,
                                        )
                                      : textoParqProx(
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
              onPressed: () async {
                var listaParques = await _fetchAndSortParques(
                    context.read<ParquesRepository>());
                setState(() {
                  ordenarPorDistanciaCrescente = !ordenarPorDistanciaCrescente;
                  buildLista(listaParques);
                });
              },
              icon: Icon(ordenarPorDistanciaCrescente
                  ? Icons.arrow_upward
                  : Icons.arrow_downward),
              label: Text(
                  'Ordenar por distância ${ordenarPorDistanciaCrescente ? 'decrescente' : 'crescente'}'),
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
    final lista = await context.read<ParquesRepository>().getLots();
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
