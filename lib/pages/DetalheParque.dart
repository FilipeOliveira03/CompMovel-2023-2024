import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter/material.dart';
import 'package:proj_comp_movel/classes/Incidente.dart';
import 'package:proj_comp_movel/main_page.dart';
import 'package:proj_comp_movel/pages/Mapa.dart';
import 'package:proj_comp_movel/pages/RegistoIncidentes.dart';
import 'package:provider/provider.dart';

import '../classes/Parque.dart';
import '../pages.dart';

class DetalheParque extends StatelessWidget {
  final Parque parque;

  const DetalheParque({Key? key, required this.parque});

  @override
  Widget build(BuildContext context) {
    var barra = Divider(
      height: 20,
      thickness: 2,
      color: Colors.grey,
      indent: 20,
      endIndent: 20,
    );

    Color corDisponibilidade;

    switch (parque.disponibilidade) {
      case DISPONIBILIDADE.DISPONIVEL:
        corDisponibilidade = Colors.green;
        break;
      case DISPONIBILIDADE.PARCIALMENTE_LOTADO:
        corDisponibilidade = Colors.amber;
        break;
      case DISPONIBILIDADE.QUASE_LOTADO:
        corDisponibilidade = Colors.redAccent;
        break;
      case DISPONIBILIDADE.LOTADO:
        corDisponibilidade = Colors.red.shade900;
        break;
    }

    Color preto = Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text(parque.nome),
      ),
      body: DefaultTextStyle(
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            informacaoParque(
              parque: parque,
              barra: barra,
              corDisponibilidade: corDisponibilidade,
              preto: preto,
            ),
            barra,
            Expanded(
              child: incidentesReportados(parque: parque),
            ),
            barra,
            butoesBaixo(),
          ],
        ),
      ),
    );
  }
}

class informacaoParque extends StatelessWidget {
  const informacaoParque({
    Key? key,
    required this.parque,
    required this.barra,
    required this.corDisponibilidade,
    required this.preto,
  }) : super(key: key);

  final Parque parque;
  final Divider barra;
  final Color corDisponibilidade;
  final Color preto;

  @override
  Widget build(BuildContext context) {
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
            child: parque.assertImagem != null
                ? Image.asset(
                    parque.assertImagem!,
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
          barra,
          textoDistancia(parque: parque),
          textoInformacoes(
            textoNegrito: 'Disponibilidade: ',
            textoNormal: parque.disponibilidade.string,
            cor: corDisponibilidade,
          ),
          textoInformacoes(
            textoNegrito: 'Lotação: ',
            textoNormal: '${parque.lotAtual}/${parque.lotMaxima}',
            cor: preto,
          ),
          textoInformacoes(
            textoNegrito: 'Horário: ',
            textoNormal:
                '${parque.horarioAbertura.hour}:${parque.horarioAbertura.minute.toString().padLeft(2, '0')} - ${parque.horarioFecho.hour}:${parque.horarioFecho.minute.toString().padLeft(2, '0')}',
            cor: preto,
          ),
          textoInformacoes(
            textoNegrito: 'Preço p/hora: ',
            textoNormal: '${parque.preco.toStringAsFixed(2)}€',
            cor: preto,
          ),
          textoInformacoes(
            textoNegrito: 'Tipo de Parque: ',
            textoNormal: parque.tipoParque.string,
            cor: preto,
          ),
          textoInformacoes(
            textoNegrito: 'Morada: ',
            textoNormal: parque.morada,
            cor: preto,
          ),
        ],
      ),
    );
  }
}

class textoDistancia extends StatelessWidget {
  const textoDistancia({
    Key? key,
    required this.parque,
  }) : super(key: key);

  final Parque parque;

  @override
  Widget build(BuildContext context) {
    var textoDistancia = '';

    if (parque.distancia.toString().length > 3) {
      textoDistancia =
          '${parque.distancia ~/ 1000}.${(parque.distancia ~/ 100) % 10} km ';
    } else {
      textoDistancia = '${parque.distancia} m ';
    }

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

class textoInformacoes extends StatelessWidget {
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
            text: textoNegrito,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: textoNormal,
            style: TextStyle(
              color: cor,
            ),
          ),
        ],
      ),
    );
  }
}

class butoesBaixo extends StatelessWidget {
  const butoesBaixo({Key? key}) : super(key: key);

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

class incidentesReportados extends StatelessWidget {
  const incidentesReportados({
    Key? key,
    required this.parque,
  }) : super(key: key);

  final Parque parque;

  @override
  Widget build(BuildContext context) {
    if (parque.incidentes.isEmpty) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.15,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Não foram reportados incidentes')],
        ),
      );
    }
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      child: ListView.builder(
        physics: ClampingScrollPhysics(),
        itemCount: parque.incidentes.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return IntrinsicHeight(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                parque.incidentes[index].tituloCurto,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26,
                                ),
                              ),
                              Text(
                                'Gravidade: ${parque.incidentes[index].gravidade}',
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
                                    parque.incidentes[index].descricaoDetalhada,
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
                              if (parque.incidentes[index].imagem != null)
                                Container(
                                  width: 200,
                                  height: 180,
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
                                  child: Image(
                                    image: XFileImage(
                                        parque.incidentes[index].imagem!),
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              if (parque.incidentes[index].imagem != null)
                                SizedBox(
                                  height: 8,
                                ),
                              Text(
                                '${parque.incidentes[index].data.day}/${parque.incidentes[index].data.month}/${parque.incidentes[index].data.year} ${parque.incidentes[index].data.hour.toString().padLeft(2, '0')}:${parque.incidentes[index].data.minute.toString().padLeft(2, '0')}',
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
                        parque.incidentes[index].tituloCurto,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Gravidade: ${parque.incidentes[index].gravidade}',
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
                        '${parque.incidentes[index].data.day}/${parque.incidentes[index].data.month}/${parque.incidentes[index].data.year} ${parque.incidentes[index].data.hour.toString().padLeft(2, '0')}:${parque.incidentes[index].data.minute.toString().padLeft(2, '0')}',
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
