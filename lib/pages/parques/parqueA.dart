import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:proj_comp_movel/classes/Incidente.dart';

import '../../classes/Parque.dart';
import '../../pages.dart';

class ParqueA extends StatelessWidget {
  const ParqueA({Key? key});

  @override
  Widget build(BuildContext context) {
    var barra = Divider(
      height: 20,
      thickness: 2,
      color: Colors.grey,
      indent: 20,
      endIndent: 20,
    );

    TimeOfDay horaAbertura = TimeOfDay(hour: 8, minute: 00);
    TimeOfDay horaFecho = TimeOfDay(hour: 22, minute: 00);

    var parque = Parque(
        "Parque A",
        DISPONIBILIDADE.PARCIALMENTE_LOTADO,
        TIPOPARQUE.ESTRUTURA,
        468,
        564,
        horaAbertura,
        horaFecho,
        "Rua do Parque A",
        1.30,
        'assets/parqueA.jpg',
    );

    var incidente = Incidente("Buraco no chão", DateTime(2024, 3, 29, 8, 00) , "Existe um buraco no chão enorme perto da zona de pagamento", 4);

    parque.incidentes.add(incidente);
    parque.incidentes.add(incidente);
    parque.incidentes.add(incidente);
    parque.incidentes.add(incidente);

    Color corDisponibilidade;

    switch (parque.disponibilidade) {
      case DISPONIBILIDADE.DISPONIVEL:
        corDisponibilidade = Colors.green;
      case DISPONIBILIDADE.PARCIALMENTE_LOTADO:
        corDisponibilidade = Colors.amber;
      case DISPONIBILIDADE.LOTADO:
        corDisponibilidade = Colors.red;
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
            Container(
              height: 360,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
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
                    child: Image.asset(
                      parque.assertImagem,
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  barra,
                  textoInformacoes('Disponibilidade: ', parque.disponibilidade.string, corDisponibilidade),
                  textoInformacoes('Lotação: ', '${parque.lotAtual}/${parque.lotMaxima}', preto),
                  textoInformacoes('Horário: ', '${parque.horarioAbertura.hour}:${parque.horarioAbertura.minute.toString().padLeft(2, '0')} - ${parque.horarioFecho.hour}:${parque.horarioFecho.minute.toString().padLeft(2, '0')}', preto),
                  textoInformacoes('Preço p/hora: ', '${parque.preco.toStringAsFixed(2)}€', preto),
                  textoInformacoes('Tipo de Parque: ', parque.tipoParque.string, preto),
                  textoInformacoes('Morada: ', parque.morada, preto),
                ],
              ),
            ),
            barra,
            Container(
              height: 190,
              child: ListView.builder(
                physics: ClampingScrollPhysics(),
                itemCount: parque.incidentes.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                parque.incidentes[index].titulo,
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
            ),
            barra,
            Container(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      'Encontrar no mapa',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {},
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
            ),
          ],
        ),
      ),
    );
  }

  RichText textoInformacoes(String textoNegrito, String textoNormal, Color corDisponibilidade) {

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
                          color: corDisponibilidade,
                        )
                      ),
                    ],
                  ),
                );
  }
}
