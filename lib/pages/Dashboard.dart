import 'package:flutter/material.dart';
import 'package:proj_comp_movel/pages.dart';

import '../classes/Parque.dart';
import 'DetalheParque.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  TextEditingController textEditingController = TextEditingController();

  var parques = minhaListaParques.parques;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pages[0].title),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          SizedBox(height: 15,),
          SearchBarApp(),
          SizedBox(height: 15,),
          textoInfoWidget(texto1: 'Parques próximos', texto2: 'Ver todos'),
          SizedBox(height: 15,),
          miniMapaWidget(),
          SizedBox(height: 15,),
          SizedBox(
            height: 250,
            width: 400,
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                var lista = minhaListaParques;
                lista.parques.sort((a, b) => a.distancia.compareTo(b.distancia));
                Parque parque = lista.parques[index];

                return GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetalheParque(parque: parque)),
                    );
                  },
                  child: Container(
                      margin: EdgeInsets.only(bottom: 10, right: 15, left: 15),
                    child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  textoParqProx(parque.nome, 18, Colors.black, FontWeight.bold),
                                  textoParqProx(parque.distancia.toString(), 20, Colors.black, FontWeight.bold),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  textoParqProx('${parque.preco.toStringAsFixed(2)}€/hr', 14, Colors.black54, FontWeight.normal),
                                  textoParqProx('${parque.lotMaxima - parque.lotAtual} Lugares Vazios!', 14, Colors.green, FontWeight.bold),
                                  textoParqProx('km de si', 14, Colors.black54, FontWeight.normal),
                                ],
                              ),
                            ],
                          ),
                        )
                    ),
                  )
                );
              },
            ),
          )
        ]),
      ),
    );
  }

  Text textoParqProx(String label, double? tamanho, Color cor, FontWeight font) {
    return Text(
      label,
      style:TextStyle(
        fontSize: tamanho,
        color: cor,
        fontWeight: font,
      ),
    );
  }
}

class miniMapaWidget extends StatelessWidget {
  const miniMapaWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            'assets/maps_aumentado.png',
            fit: BoxFit.cover,
            height: 190,
            width: 360,
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 1,
                color: Colors.black.withOpacity(0.3),
                style: BorderStyle.solid,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class textoInfoWidget extends StatelessWidget {
  const textoInfoWidget({
    super.key,
    required this.texto1,
    required this.texto2,
  });

  final String texto1;
  final String texto2;

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                texto1,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  //falta aqui fazer qualquer coisa que não sei
                },
                child: Text(
                  texto2,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
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
