import 'package:flutter/material.dart';
import 'package:proj_comp_movel/classes/Incidente.dart';
import 'package:proj_comp_movel/classes/ParquesRepository.dart';

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

enum DISPONIBILIDADE { DISPONIVEL, PARCIALMENTE_LOTADO, QUASE_LOTADO, LOTADO }

extension DISPONIBILIDADEExtension on DISPONIBILIDADE {
  String get string {
    switch (this) {
      case DISPONIBILIDADE.DISPONIVEL:
        return 'Disponível';
      case DISPONIBILIDADE.PARCIALMENTE_LOTADO:
        return 'Parcialmente Lotado';
      case DISPONIBILIDADE.QUASE_LOTADO:
        return 'Quase Lotado';
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
  int distancia;
  TIPOPARQUE tipoParque;
  TimeOfDay horarioAbertura;
  TimeOfDay horarioFecho;
  // String horarioSemanal;
  String morada;
  double preco;
  String? assertImagem;
  List<Incidente> incidentes = [];

  Parque(
      {required this.nome,
      required this.disponibilidade,
      required this.tipoParque,
      required this.lotAtual,
      required this.lotMaxima,
      required this.distancia,
      required this.horarioAbertura,
      required this.horarioFecho,
      required this.morada,
      required this.preco,
      this.assertImagem});

  factory Parque.fromMap(Map<String, dynamic> map){
    return Parque(nome: map['nome'], disponibilidade: DISPONIBILIDADE.DISPONIVEL, tipoParque: TIPOPARQUE.ESTRUTURA /*map['tipo']*/, lotAtual: map['ocupacao'], lotMaxima: map['capacidade_max'], distancia: 0, horarioAbertura: TimeOfDay(hour: 0, minute: 00), horarioFecho: TimeOfDay(hour: 0, minute: 00), morada: 'morada em falta', preco: 0.00);
  }
}
