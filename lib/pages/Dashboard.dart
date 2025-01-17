import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:proj_comp_movel/classes/Incidente.dart';
import 'package:proj_comp_movel/pages.dart';
import 'package:proj_comp_movel/repository/ParquesRepository.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

import '../classes/Lote.dart';
import '../data/parquesDatabase.dart';
import 'DetalheParque.dart';
import 'Mapa.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  String textoLabel(Incidente incidente) {
    var nomeParque = incidente.nomeParque.split(' ');

    if (nomeParque.contains('Parque')) {
      return '   ⚠️   Incidente reportado no ${incidente.nomeParque}, às ${incidente.data.hour}:${incidente.data.minute}!';
    } else {
      return '   ⚠️   Incidente reportado no Parque ${incidente.nomeParque}, às ${incidente.data.hour}:${incidente.data.minute}!';
    }
  }

  Future<Position> _getCurrentLocation() async {
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

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {

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
            buildIncidentesWidget(),
            barra,
            textoInfoWidget(texto1: 'Parques próximos'),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Mapa(),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Expanded(
              child: FutureBuilder(
                future: _getCurrentLocation(),
                builder: (context, AsyncSnapshot<Position> snapshot) {
                  if (snapshot.hasError) {
                    return tresParquesProxWidget(
                      userLocation: null,
                    );
                  } else {
                    Position? position = snapshot.data;
                    return tresParquesProxWidget(
                      userLocation: position,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class buildIncidentesWidget extends StatelessWidget {
  const buildIncidentesWidget({
    super.key,
  });

  String textoLabel(Incidente incidente) {
    var nomeParque = incidente.nomeParque.split(' ');

    if (nomeParque.contains('Parque')) {
      return '   ⚠️   Incidente reportado no ${incidente.nomeParque}, às ${incidente.data.hour.toString().padLeft(2, '0')}:${incidente.data.minute.toString().padLeft(2, '0')}!';
    } else {
      return '   ⚠️   Incidente reportado no Parque ${incidente.nomeParque}, às ${incidente.data.hour.toString().padLeft(2, '0')}:${incidente.data.minute.toString().padLeft(2, '0')}!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final database = context.read<ParquesDatabase>();

    return FutureBuilder(
        future: database.getIncidentesRecentes(),
        builder: (_, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            } else {
              return buildIncidentes(snapshot.data ?? [], context);
            }
          }
        });
  }

  SizedBox buildIncidentes(List<Incidente> incidentes, BuildContext context) {
    incidentes.sort((a, b) => b.data.compareTo(a.data));

    incidentes.sort((a, b) {
      if (b.data.hour != a.data.hour) {
        return b.data.hour.compareTo(a.data.hour);
      } else if (b.data.minute != a.data.minute) {
        return b.data.minute.compareTo(a.data.minute);
      } else {
        return b.data.second.compareTo(a.data.second);
      }
    });

    String incidente;
    if (incidentes.isEmpty) {
      incidente = '       Não foram reportados incidentes recentemente!';
    } else if (incidentes.length == 1) {
      incidente = textoLabel(incidentes[0]);
    } else if (incidentes.length == 2) {
      incidente = '${textoLabel(incidentes[0])} ${textoLabel(incidentes[1])}';
    } else {
      incidente =
          '${textoLabel(incidentes[0])} ${textoLabel(incidentes[1])} ${textoLabel(incidentes[2])}';
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.03,
      width: MediaQuery.of(context).size.width * 0.92,
      child: Marquee(
        text: incidente,
        style: TextStyle(
          fontSize: 18,
        ),
        velocity: 40,
      ),
    );
  }
}

class tresParquesProxWidget extends StatefulWidget {
  const tresParquesProxWidget({super.key, this.userLocation});

  final Position? userLocation;

  @override
  State<tresParquesProxWidget> createState() => _tresParquesProxState();
}

class _tresParquesProxState extends State<tresParquesProxWidget> {
  List<Lote> minhaListaParques = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final parquesRepository =
        Provider.of<ParquesRepository>(context, listen: false);
    minhaListaParques = await parquesRepository.getLots();
    if (widget.userLocation != null) {
      for (var parque in minhaListaParques) {
        parque.distancia = Geolocator.distanceBetween(
          widget.userLocation!.latitude,
          widget.userLocation!.longitude,
          double.parse(parque.latitude),
          double.parse(parque.longitude),
        );
      }
      minhaListaParques.sort((a, b) => a.distancia!.compareTo(b.distancia!));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final parquesRepository =
        Provider.of<ParquesRepository>(context, listen: false);
    return FutureBuilder(
      future: parquesRepository.getLots(),
      builder: (_, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasError) {
            return Text('Error');
          } else {
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
            }
          }
        }
      },
    );
  }
}

class listaParquesPertoWidget extends StatelessWidget {
  const listaParquesPertoWidget(
      {super.key, required this.lista, required this.itemCount});

  final List<Lote> lista;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        Lote lote = lista[index];

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
        } else if (lotAtual < 0) {
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
                        lote.distancia != null && lote.distancia! >= 1000
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
