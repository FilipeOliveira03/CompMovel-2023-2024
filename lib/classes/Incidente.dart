import 'dart:ui';

import 'package:flutter/material.dart';

class Incidente{

  String tituloCurto;
  DateTime data;
  String descricaoDetalhada;
  int gravidade;
  String? assertImagem;

  Incidente(this.tituloCurto ,this.data, this.descricaoDetalhada, this.gravidade, this.assertImagem);
}