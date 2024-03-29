import 'dart:ui';

import 'package:flutter/material.dart';

class Incidente{

  TimeOfDay hora;
  DateTime data;
  String descricao;
  int gravidade;
  late Image imagem;

  Incidente(this.data, this.hora, this.descricao, this.gravidade);
}