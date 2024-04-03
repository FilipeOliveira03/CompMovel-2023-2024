import 'dart:ui';

import 'package:flutter/material.dart';

class Incidente{

  String nomeParque;
  String tituloCurto;
  DateTime data;
  String descricaoDetalhada;
  int gravidade;
  String? assertImagem;

  Incidente(this.nomeParque, this.tituloCurto ,this.data, this.descricaoDetalhada, this.gravidade, this.assertImagem);
}