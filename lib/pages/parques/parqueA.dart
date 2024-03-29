import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        DISPONIBILIDADE.Disponivel,
        TIPOPARQUE.Estrutura,
        564,
        horaAbertura,
        horaFecho,
        "Rua do Parque A",
        1.30);

    var incidente = Incidente(DateTime(2024, 3, 29), TimeOfDay(hour: 8, minute: 00), "Buraco no chão", 4);

    parque.incidentes.add(incidente);
    parque.incidentes.add(incidente);
    parque.incidentes.add(incidente);
    parque.incidentes.add(incidente);

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
                      'assets/parqueA.jpg',
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  barra,
                  Text('Lotação: ${parque.disponibilidade.name}'),
                  Text('Lotação: ${parque.lotAtual}/${parque.lotMaxima}'),
                  Text('Horario: ${parque.horarioAbertura.hour}:${parque.horarioAbertura.minute.toString().padLeft(2, '0')} - ${parque.horarioFecho.hour}:${parque.horarioFecho.minute.toString().padLeft(2, '0')}'),
                  Text('Preço p/hora: ${parque.preco}€'),
                  Text('Tipo de Parque: ${parque.tipoParque.name}'),
                  Text('Morada: ${parque.morada}'),

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
                      onTap: () {},
                      title: Text(parque.incidentes[index].descricao),
                    ),
                  );
                },
              ),
            ),
            barra,
            // Parte 3: Botões
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
}
