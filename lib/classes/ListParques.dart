import 'package:flutter/material.dart';

import 'Parque.dart';

class ListParques{

  String zona;
  List<Parque> parques = [
    Parque(
      "Parque A",
      DISPONIBILIDADE.PARCIALMENTE_LOTADO,
      TIPOPARQUE.ESTRUTURA,
      468,
      564,
      TimeOfDay(hour: 8, minute: 00),
      TimeOfDay(hour: 22, minute: 00),
      "Rua do Parque A",
      1.30,
      'assets/parqueA.jpg',
    ),
    Parque(
      'Parque B',
      DISPONIBILIDADE.LOTADO,
      TIPOPARQUE.SUPERFICIE,
      33,
      3330,
      TimeOfDay(hour: 9, minute: 0),
      TimeOfDay(hour: 18, minute: 0),
      'Morada do Parque B',
      3.0,
      'assert_imagem_b.jpg',
    ),
    Parque(
      "Parque C",
      DISPONIBILIDADE.PARCIALMENTE_LOTADO,
      TIPOPARQUE.ESTRUTURA,
      468,
      564,
      TimeOfDay(hour: 8, minute: 00),
      TimeOfDay(hour: 22, minute: 00),
      "Rua do Parque C",
      1.30,
      'assets/parqueC.jpg',
    ),

  ];

  ListParques(this.zona);
}