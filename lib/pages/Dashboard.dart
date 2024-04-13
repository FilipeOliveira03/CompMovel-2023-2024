import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:proj_comp_movel/classes/Incidente.dart';
import 'package:proj_comp_movel/pages.dart';

import '../classes/Parque.dart';
import '../main.dart';
import 'DetalheParque.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  String textoLabel(Incidente incidente) {
    return '   ⚠️   Incidente reportado no Parque ${incidente.nomeParque}, ás ${incidente.data.hour}:${incidente.data.minute}!';
  }

  @override
  Widget build(BuildContext context) {
    var listaIncidentesTotais = minhaListaIncidentes.incidentes.toList();

    listaIncidentesTotais.sort((a, b) => b.data.compareTo(a.data));

    var incidente;
    if (listaIncidentesTotais.isEmpty) {
      incidente = '       Não foram reportados incidentes recentemente!';
    } else if (listaIncidentesTotais.length == 1) {
      incidente = textoLabel(listaIncidentesTotais[0]);
    } else if (listaIncidentesTotais.length == 2) {
      incidente =
          '${textoLabel(listaIncidentesTotais[0])} ${textoLabel(listaIncidentesTotais[1])}';
    } else {
      incidente =
          '${textoLabel(listaIncidentesTotais[0])} ${textoLabel(listaIncidentesTotais[1])} ${textoLabel(listaIncidentesTotais[2])}';
    }

    print(incidente);

    var barra = Divider(
      height: 20,
      thickness: 2,
      color: Colors.grey,
      indent: 15,
      endIndent: 15,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(pages[0].title),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          SizedBox(
            height: 10,
          ),
          barra,
          SizedBox(
            height: 30,
            width: 365,
            child: Marquee(
              text: incidente,
              style: TextStyle(
                fontSize: 18,
              ),
              velocity: 40,
            ),
          ),
          barra,
          textoInfoWidget(texto1: 'Parques próximos'),
          SizedBox(
            height: 10,
          ),
          miniMapaWidget(),
          SizedBox(
            height: 10,
          ),
          tresParquesProxWidget()
        ]),
      ),
    );
  }
}

class tresParquesProxWidget extends StatelessWidget {
  const tresParquesProxWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: 400,
      child: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          var lista = List<Parque>.from(minhaListaParques.parques);
          lista.sort((a, b) => a.distancia.compareTo(b.distancia));
          Parque parque = lista[index];

          var lotAtual = parque.lotMaxima - parque.lotAtual;

          var corLotacao;

          if(lotAtual == 0){
            corLotacao = Colors.red;
          }else if(lotAtual < (parque.lotMaxima * 0.1).toInt()){
            corLotacao = Colors.amber;
          } else{
            corLotacao = Colors.green;
          }

          return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetalheParque(parque: parque)),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            textoParqProx(
                                label: '${parque.preco.toStringAsFixed(2)}€/hr',
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
    );
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
  });

  final String texto1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            texto1,
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
