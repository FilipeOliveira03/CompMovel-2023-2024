import 'dart:ui';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';

class Incidente {
  String idParque;
  String nomeParque;
  String tituloCurto;
  DateTime data;
  String? descricaoDetalhada;
  int gravidade;

  Incidente({
    required this.idParque,
    required this.nomeParque,
    required this.tituloCurto,
    required this.data,
    this.descricaoDetalhada,
    required this.gravidade,
}
       );

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

  factory Incidente.fromDB(Map<String, dynamic> db) {

    var dataDb = db['data'].split(' ');
    var diaMesAno = dataDb[0].split('-');
    var horaMinutoSegundo = dataDb[1].split('.')[0].split(':');
    var ano = int.parse(diaMesAno[0]);
    var mes = int.parse(diaMesAno[1]);
    var dia = int.parse(diaMesAno[2]);
    var hora = int.parse(horaMinutoSegundo[0]);
    var minuto = int.parse(horaMinutoSegundo[1]);
    var segundo = int.parse(horaMinutoSegundo[2]);

    DateTime data = DateTime(ano, mes, dia, hora, minuto, segundo);
    print(db['descricaoDetalhada']);
    return Incidente(
        idParque: db['idParque'],
        nomeParque: db['nomeParque'],
        tituloCurto: db['tituloCurto'],
        data: data,
        descricaoDetalhada: db['descricaoDetalhada'],
        gravidade: db['gravidade']
    );
  }

}

class ListaIncidente {
  List<Incidente> incidentes = [];

  ListaIncidente();
}
