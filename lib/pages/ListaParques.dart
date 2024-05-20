import 'package:flutter/material.dart';
import 'package:proj_comp_movel/pages/DetalheParque.dart';
import 'package:provider/provider.dart';
import '../classes/Parque.dart';
import '../classes/ParquesRepository.dart';
import '../pages.dart';

class ListaParques extends StatefulWidget {
  const ListaParques({Key? key}) : super(key: key);

  @override
  State<ListaParques> createState() => _ListaParquesState();
}

class _ListaParquesState extends State<ListaParques> {
  bool ordenarPorDistanciaCrescente = true;

  @override
  Widget build(BuildContext context) {

    List<Parque> listaParques = context.read<ParquesRepository>().getParques();

    void ordenarParquesPorDistancia() {
      setState(() {
        listaParques.sort((a, b) => b.distancia.compareTo(a.distancia));
        ordenarPorDistanciaCrescente = !ordenarPorDistanciaCrescente;
        if (ordenarPorDistanciaCrescente) {
          listaParques.sort((a, b) => a.distancia.compareTo(b.distancia));
        }
      });
    }

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
                itemCount: listaParques.length,
                itemBuilder: (context, index) {
                  Parque parque = listaParques[index];
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
                          builder: (context) => DetalheParque(parque: parque),
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
                                    label: parque.nome,
                                    tamanho: 18,
                                    cor: Colors.black,
                                    font: FontWeight.bold,
                                  ),
                                  textoParqProx(
                                    label: parque.distancia.toString(),
                                    tamanho: 20,
                                    cor: Colors.black,
                                    font: FontWeight.bold,
                                  ),
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
                                    font: FontWeight.normal,
                                  ),
                                  textoParqProx(
                                    label:
                                        '${parque.lotMaxima - parque.lotAtual} Lugares Vazios!',
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
    final minhaListaParques = context.read<ParquesRepository>().getParques();
    return minhaListaParques
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
    final minhaListaParques = context.read<ParquesRepository>().getParques();
    return SizedBox(
      height: 45,
      width: MediaQuery.of(context).size.width * 0.9,
      child: SearchAnchor.bar(
        barHintText: 'Procura parques',
        onSubmitted: (String value) {
          bool existe = false;
          var parqueEncontrado;

          for (var i = 0; i < minhaListaParques.length; i++) {
            if (minhaListaParques[i].nome == value) {
              existe = true;
              parqueEncontrado = minhaListaParques[i];
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
