import 'package:flutter/material.dart';

import '../../classes/Parque.dart';
import '../../pages.dart';

class ParqueA extends StatelessWidget {
  const ParqueA({super.key});

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

    return Scaffold(
      appBar: AppBar(
        title: Text(parque.nome),
      ),
      body: DefaultTextStyle(
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 25,
              ),
              Container(
                width: 350,
                height: 250,
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
              SizedBox(
                height: 35,
              ),
              Text('Lotação: ${parque.disponibilidade.name}'),
              barra,
              Text('Lotação: ${parque.lotAtual}/${parque.lotMaxima}'),
              barra,
              Text(
                  'Horario: ${parque.horarioAbertura.hour}:${parque.horarioAbertura.minute.toString().padLeft(2, '0')} - ${parque.horarioFecho.hour}:${parque.horarioFecho.minute.toString().padLeft(2, '0')}'),
              barra,
              Text('Preço p/hora: ${parque.preco}€'),
              barra,
              Text('Tipo de Parque: ${parque.tipoParque.name}'),
              barra,
              Text('Morada: ${parque.morada}'),
              SizedBox(
                height: 35,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: Text(
                          'Encontrar no mapa',
                          style: TextStyle(color: Colors.black),
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: Text('Reportar Incidente',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
