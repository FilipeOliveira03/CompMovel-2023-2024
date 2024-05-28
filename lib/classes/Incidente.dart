import 'dart:ui';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';

class Incidente {
  String idParque;
  String nomeParque;
  String tituloCurto;
  DateTime data;
  String descricaoDetalhada;
  int gravidade;

  Incidente(
      this.idParque,
      this.nomeParque,
      this.tituloCurto,
      this.data,
      this.descricaoDetalhada,
      this.gravidade);

  Map<String, dynamic> toDb(){
    return{
      'idParque': idParque,
      'nomeParque': nomeParque,
      'tituloCurto': tituloCurto,
      'data': data.toString(),
      'descricaoDetalhada': descricaoDetalhada,
      'gravidade': gravidade,
    };
  }

}

class ListaIncidente {
  List<Incidente> incidentes = [];

  ListaIncidente();
}
