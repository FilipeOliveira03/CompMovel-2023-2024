import 'dart:ui';

import 'package:flutter/material.dart';

class Incidente{

  String titulo;
  DateTime data;
  String descricaoDetalhada;
  int gravidade;
  late Image imagem;

  Incidente(this.titulo ,this.data, this.descricaoDetalhada, this.gravidade);
}