import 'package:flutter/material.dart';
import 'package:proj_comp_movel/classes/Incidente.dart';
import 'package:proj_comp_movel/main_page.dart';
import 'package:provider/provider.dart';

import '../classes/Lote.dart';
import '../classes/Tarifa.dart';
import '../classes/Zone.dart';
import '../data/parquesDatabase.dart';
import '../repository/ParquesRepository.dart';

class DetalheParque extends StatefulWidget {
  final Lote lote;

  const DetalheParque({Key? key, required this.lote});

  @override
  State<DetalheParque> createState() => _DetalheParqueState();
}

class _DetalheParqueState extends State<DetalheParque> {
  Zone? zona;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final parquesRepository =context.read<ParquesRepository>();

    var barra = Divider(
      height: 20,
      thickness: 2,
      color: Colors.grey,
      indent: 20,
      endIndent: 20,
    );

    Color corDisponibilidade = Colors.white10;

    // switch (parque.disponibilidade) {
    //   case DISPONIBILIDADE.DISPONIVEL:
    //     corDisponibilidade = Colors.green;
    //     break;
    //   case DISPONIBILIDADE.PARCIALMENTE_LOTADO:
    //     corDisponibilidade = Colors.amber;
    //     break;
    //   case DISPONIBILIDADE.QUASE_LOTADO:
    //     corDisponibilidade = Colors.redAccent;
    //     break;
    //   case DISPONIBILIDADE.LOTADO:
    //     corDisponibilidade = Colors.red.shade900;
    //     break;
    // }

    Color preto = Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lote.nome),
      ),
      body: DefaultTextStyle(
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
          child: FutureBuilder(
            future: parquesRepository.getZones(widget.lote.id),
            builder: (_, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasError) {
                  return Text('Error');
                } else {
                  return buildDetails(
                      snapshot.data!, barra, corDisponibilidade, preto);
                }
              }
            },
          )),
    );
  }

  Widget buildDetails(
      Zone zona, Divider barra, Color corDisponibilidade, Color preto) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        informacaoParque(
          lote: widget.lote,
          zona: zona,
          barra: barra,
          corDisponibilidade: corDisponibilidade,
          preto: preto,
        ),
        barra,
        Expanded(
          child: incidentesReportados(lote: widget.lote),
        ),
        barra,
        butoesBaixo(),
      ],
    );
  }
}

class informacaoParque extends StatefulWidget {
  const informacaoParque({
    Key? key,
    required this.lote,
    required this.zona,
    required this.barra,
    required this.corDisponibilidade,
    required this.preto,
  }) : super(key: key);

  final Lote lote;
  final Zone? zona;
  final Divider barra;
  final Color corDisponibilidade;
  final Color preto;

  @override
  State<informacaoParque> createState() => _informacaoParqueState();
}

class _informacaoParqueState extends State<informacaoParque> {
  @override
  Widget build(BuildContext context) {
    var tarifa = Tarifas().tarifas.firstWhere((element) =>
        element.cor.toLowerCase() == widget.zona!.tarifa.toLowerCase());

    var lotAtual = widget.lote.lotAtual;

    if (lotAtual < 0) {
      lotAtual = widget.lote.lotMaxima;
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.48,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: widget.lote.assertImagem != null
                ? Image.asset(
                    widget.lote.assertImagem!,
                    width: 350,
                    height: 350,
                    fit: BoxFit.cover,
                  )
                : Center(
                    child: Text(
                      'Sem imagem disponível',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
          ),
          SizedBox(height: 10),
          widget.barra,
          textoDistancia(
            zone: widget.zona,
            lote: widget.lote,
          ),
          textoInformacoes(
            textoNegrito: 'Horário: ',
            textoNormal: widget.zona!.horarioespecifico.toLowerCase(),
            cor: widget.preto,
          ),
          textoInformacoes(
            textoNegrito: 'Lotação: ',
            textoNormal: '$lotAtual/${widget.lote.lotMaxima}',
            cor: widget.preto,
          ),
          textoInformacoes(
            textoNegrito: 'Tipo de Parque: ',
            textoNormal: widget.lote.tipoParque.trim(),
            cor: widget.preto,
          ),
          textoInformacoes(
            textoNegrito: 'Tarifa: ',
            textoNormal: tarifa.cor,
            cor: widget.preto,
          ),
          textoInformacoes(
            textoNegrito: 'Preço p/hora: ',
            textoNormal: '${tarifa.preco.toString()}€',
            cor: widget.preto,
          ),

          textoInformacoes(
            textoNegrito: 'Informação atualizada as ',
            textoNormal: widget.lote.dataAtualizacao.split(' ')[1],
            cor: widget.preto,
          ),
        ],
      ),
    );
  }
}

class textoDistancia extends StatefulWidget {
  const textoDistancia({
    Key? key,
    required this.lote,
    required this.zone,
  }) : super(key: key);

  final Lote lote;
  final Zone? zone;

  @override
  State<textoDistancia> createState() => _textoDistanciaState();
}

class _textoDistanciaState extends State<textoDistancia> {
  @override
  Widget build(BuildContext context) {
    var textoDistancia = '';

    // if (widget.parque.distancia.toString().length > 3) {
    //   textoDistancia =
    //       '${widget.parque.distancia ~/ 1000}.${(widget.parque.distancia ~/ 100) % 10} km ';
    // } else {
    //   textoDistancia = '${widget.parque.distancia} m ';
    // }

    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
        children: <TextSpan>[
          TextSpan(
            text: 'Parque a ',
          ),
          TextSpan(
            text: textoDistancia,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          TextSpan(
            text: 'de si',
          ),
        ],
      ),
    );
  }
}

class textoInformacoes extends StatefulWidget {
  const textoInformacoes({
    Key? key,
    required this.textoNegrito,
    required this.textoNormal,
    required this.cor,
  }) : super(key: key);

  final String textoNegrito;
  final String textoNormal;
  final Color cor;

  @override
  State<textoInformacoes> createState() => _textoInformacoesState();
}

class _textoInformacoesState extends State<textoInformacoes> {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
        children: <TextSpan>[
          TextSpan(
            text: widget.textoNegrito,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: widget.textoNormal,
            style: TextStyle(
              color: widget.cor,
            ),
          ),
        ],
      ),
    );
  }
}

class butoesBaixo extends StatefulWidget {
  const butoesBaixo({Key? key}) : super(key: key);

  @override
  State<butoesBaixo> createState() => _butoesBaixoState();
}

class _butoesBaixoState extends State<butoesBaixo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          OutlinedButton(
            onPressed: () {
              context.read<MainPageViewModel>().selectedIndex = 2;
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: Text(
              'Encontrar no mapa',
              style: TextStyle(color: Colors.black),
            ),
          ),
          OutlinedButton(
            onPressed: () {
              context.read<MainPageViewModel>().selectedIndex = 3;
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: Text(
              'Reportar Incidente',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class incidentesReportados extends StatefulWidget {
  const incidentesReportados({
    Key? key,
    required this.lote,
  }) : super(key: key);

  final Lote lote;

  @override
  State<incidentesReportados> createState() => _incidentesReportadosState();
}

class _incidentesReportadosState extends State<incidentesReportados> {
  @override
  Widget build(BuildContext context) {
    final database = context.read<ParquesDatabase>();

    final incidentes = database.getIncidentes(widget.lote.id);
    return FutureBuilder(
        future: database.getIncidentes(widget.lote.id),
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
              return builderIncidentes(snapshot.data ?? [], context);
            }
          }
        });
  }

  Widget builderIncidentes(List<Incidente> incidentes, BuildContext context) {



    if (incidentes.isEmpty) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.15,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Não foram reportados incidentes')],
        ),
      );
    } else {
      return Container(
        height: MediaQuery.of(context).size.height * 0.15,
        child: ListView.builder(
          physics: ClampingScrollPhysics(),
          itemCount: incidentes.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {

                      var descricao;

                      if (incidentes[index].descricaoDetalhada == ''){
                        descricao = 'Não existe informação adicional';
                      }else{
                        descricao = incidentes[index].descricaoDetalhada;
                      }

                      return IntrinsicHeight(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  incidentes[index].tituloCurto,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 26,
                                  ),
                                ),
                                Text(
                                  'Gravidade: ${incidentes[index].gravidade}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Descrição do incidente:',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      descricao,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${incidentes[index].data.day}/${incidentes[index].data.month}/${incidentes[index].data.year} ${incidentes[index].data.hour.toString().padLeft(2, '0')}:${incidentes[index].data.minute.toString().padLeft(2, '0')}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  child: Text(
                                    'Fechar',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          incidentes[index].tituloCurto,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Gravidade: ${incidentes[index].gravidade}',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${incidentes[index].data.day}/${incidentes[index].data.month}/${incidentes[index].data.year} ${incidentes[index].data.hour.toString().padLeft(2, '0')}:${incidentes[index].data.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
