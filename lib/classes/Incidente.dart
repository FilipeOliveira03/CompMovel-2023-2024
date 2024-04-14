import 'dart:ui';
import 'package:image_picker/image_picker.dart';


import 'package:flutter/material.dart';

class Incidente {
  String nomeParque;
  String tituloCurto;
  DateTime data;
  String descricaoDetalhada;
  int gravidade;
  XFile? imagem; // Corrigido para imagem

  Incidente(this.nomeParque, this.tituloCurto, this.data, this.descricaoDetalhada, this.gravidade, this.imagem); // Corrigido para imagem
}


class ListaIncidente {

  List<Incidente> incidentes = [];

  ListaIncidente();
}