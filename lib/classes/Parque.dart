import 'package:flutter/material.dart';
import 'package:proj_comp_movel/classes/Incidente.dart';

enum TIPOPARQUE {
  ESTRUTURA,
  SUPERFICIE,
}

extension TIPOPARQUEExtension on TIPOPARQUE {
  String get string {
    switch (this) {
      case TIPOPARQUE.ESTRUTURA:
        return 'Estrutura';
      case TIPOPARQUE.SUPERFICIE:
        return 'Superfície';
    }
  }
}

enum DISPONIBILIDADE{
  DISPONIVEL,
  PARCIALMENTE_LOTADO,
  QUASE_LOTADO,
  LOTADO
}

extension DISPONIBILIDADEExtension on DISPONIBILIDADE {
  String get string {
    switch (this) {
      case DISPONIBILIDADE.DISPONIVEL:
        return 'Disponível';
      case DISPONIBILIDADE.PARCIALMENTE_LOTADO:
        return 'Parcialmente Lotado';
      case DISPONIBILIDADE.QUASE_LOTADO:
        return 'Parcialmente Lotado';
      case DISPONIBILIDADE.LOTADO:
        return 'Lotado';
    }
  }
}

class Parque {
  String nome;
  DISPONIBILIDADE disponibilidade;
  int lotAtual;
  int lotMaxima;
  TIPOPARQUE tipoParque;
  TimeOfDay horarioAbertura;
  TimeOfDay horarioFecho;
  String morada;
  double preco;
  String? assertImagem;
  List<Incidente> incidentes = [];

  Parque(this.nome, this.disponibilidade ,this.tipoParque, this.lotAtual ,this.lotMaxima, this.horarioAbertura,
      this.horarioFecho, this.morada, this.preco, this.assertImagem);

}
