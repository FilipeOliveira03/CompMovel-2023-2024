import 'package:flutter/material.dart';

import 'Parque.dart';

class ParquesRepository {

  List<Parque> getParques() {
    return [
      Parque(
        nome: "Universidade",
        disponibilidade:  DISPONIBILIDADE.PARCIALMENTE_LOTADO,
        tipoParque: TIPOPARQUE.SUPERFICIE,
        lotAtual: 468,
        lotMaxima: 578,
        distancia:  1420,
        horarioAbertura: TimeOfDay(hour: 9, minute: 00),
        horarioFecho: TimeOfDay(hour: 21, minute: 30),
        morada: "Rua da Universidade",
        preco: 1.30,
        assertImagem: null,
      ),
      Parque(
        nome: "Universidade2",
        disponibilidade:  DISPONIBILIDADE.PARCIALMENTE_LOTADO,
        tipoParque: TIPOPARQUE.SUPERFICIE,
        lotAtual: 468,
        lotMaxima: 578,
        distancia:  1420,
        horarioAbertura: TimeOfDay(hour: 9, minute: 00),
        horarioFecho: TimeOfDay(hour: 21, minute: 30),
        morada: "Rua da Universidade",
        preco: 1.30,
        assertImagem: null,
      ),
      Parque(
        nome: "Universidade3",
        disponibilidade:  DISPONIBILIDADE.PARCIALMENTE_LOTADO,
        tipoParque: TIPOPARQUE.SUPERFICIE,
        lotAtual: 468,
        lotMaxima: 578,
        distancia:  1420,
        horarioAbertura: TimeOfDay(hour: 9, minute: 00),
        horarioFecho: TimeOfDay(hour: 21, minute: 30),
        morada: "Rua da Universidade",
        preco: 1.30,
        assertImagem: null,
      ),
    ];
  }

  Parque? getParque(String id){
    return Parque(
      nome: "Universidade",
      disponibilidade:  DISPONIBILIDADE.PARCIALMENTE_LOTADO,
      tipoParque: TIPOPARQUE.SUPERFICIE,
      lotAtual: 468,
      lotMaxima: 578,
      distancia:  1420,
      horarioAbertura: TimeOfDay(hour: 9, minute: 00),
      horarioFecho: TimeOfDay(hour: 21, minute: 30),
      morada: "Rua da Universidade",
      preco: 1.30,
      assertImagem: null,
    );
  }

}