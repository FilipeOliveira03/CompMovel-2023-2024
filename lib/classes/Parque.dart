import 'package:flutter/material.dart';
import 'package:proj_comp_movel/classes/Incidente.dart';

enum TIPOPARQUE {
  Estrutura,
  Superficie,
}

enum DISPONIBILIDADE{
  Disponivel,
  Parcialmente_Lotado,
  Lotado
}

class Parque {
  String nome;
  DISPONIBILIDADE disponibilidade;
  int lotAtual = 0;
  int lotMaxima;
  TIPOPARQUE tipoParque;
  TimeOfDay horarioAbertura;
  TimeOfDay horarioFecho;
  String morada;
  double preco;
  List<Incidente> incidentes = [];

  Parque(this.nome, this.disponibilidade ,this.tipoParque, this.lotMaxima, this.horarioAbertura,
      this.horarioFecho, this.morada, this.preco);

}
