import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:proj_comp_movel/classes/Incidente.dart';
import 'package:proj_comp_movel/pages.dart';
import 'package:provider/provider.dart';

import '../classes/Lote.dart';
import '../classes/Parque.dart';
import '../classes/ParquesRepository.dart';
import '../main.dart';
import 'DetalheParque.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  String textoLabel(Incidente incidente) {
    return '   ⚠️   Incidente reportado no Parque ${incidente.nomeParque}, às ${incidente.data.hour}:${incidente.data.minute}!';
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
      incidente = '${textoLabel(listaIncidentesTotais[0])} ${textoLabel(listaIncidentesTotais[1])}';
    } else {
      incidente = '${textoLabel(listaIncidentesTotais[0])} ${textoLabel(listaIncidentesTotais[1])} ${textoLabel(listaIncidentesTotais[2])}';
    }

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            barra,
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
              width: MediaQuery.of(context).size.width * 0.92,
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
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            miniMapaWidget(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Expanded(
              child: tresParquesProxWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class tresParquesProxWidget extends StatefulWidget {
  const tresParquesProxWidget({super.key});

  @override
  State<tresParquesProxWidget> createState() => _tresParquesProxState();
}

class _tresParquesProxState extends State<tresParquesProxWidget> {
  List<Lote> minhaListaParques = []; // Initialize an empty list

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data in initState
  }

  Future<void> fetchData() async {
    final parquesRepository = Provider.of<ParquesRepository>(context, listen: false);
    minhaListaParques = await parquesRepository.getLots();
    setState(() {}); // Ensure the UI updates after fetching data
  }

  @override
  Widget build(BuildContext context) {
    var lista = List<Lote>.from(minhaListaParques);

    if (lista.length >= 3) {
      return listaParquesPertoWidget(
        lista: lista,
        itemCount: 3,
      );
    } else if (lista.length == 2) {
      return listaParquesPertoWidget(
        lista: lista,
        itemCount: 2,
      );
    } else if (lista.length == 1) {
      return listaParquesPertoWidget(
        lista: lista,
        itemCount: 1,
      );
    } else {
      return Container(
        margin: EdgeInsets.only(bottom: 10, right: 45, left: 45),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Text(
              'Não existem parques próximos de si',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                color: Colors.black,
              ),
            ),
          ),
        ),
      );
    } // Pass data to listaParquesPertoWidget
  }
}

class listaParquesPertoWidget extends StatelessWidget {
  const listaParquesPertoWidget({
    super.key,
    required this.lista,
    required this.itemCount
  });

  final List<Lote> lista;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        // lista.sort((a, b) => a.distancia.compareTo(b.distancia));
        Lote lote = lista[index];

        var lotOcupada = lote.lotAtual;

        if(lotOcupada < 0){
          lotOcupada = lote.lotMaxima;
        }

        var lotAtual = lote.lotMaxima - lotOcupada;

        var corLotacao;

        if (lotAtual == 0) {
          corLotacao = Colors.red;
        } else if (lotAtual < (lote.lotMaxima * 0.1).toInt()) {
          corLotacao = Colors.amber;
        }else if(lotAtual < 0){
          lotAtual = lote.lotMaxima;
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width * 0.8,
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
