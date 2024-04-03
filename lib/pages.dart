import 'package:flutter/material.dart';
import 'package:proj_comp_movel/pages/parques/parqueA.dart';
import 'package:proj_comp_movel/pages/parques/parqueB.dart';

import 'classes/ListParques.dart';
import 'pages/Dashboard.dart';
import 'pages/ListaParques.dart';
import 'pages/Mapa.dart';
import 'pages/RegistoIncidentes.dart';

final ListParques minhaListaParques = ListParques();

final pages = [
  (title: 'Home', icon: Icons.home, widget: Dashboard()),
  (title: 'Lista', icon: Icons.list, widget: ListaParques()),
  (title: 'Mapa', icon: Icons.map, widget: Mapa()),
  (title: 'Incidentes', icon: Icons.warning, widget: RegistoIncidentes()),
];

final pageParque = [
  (title: 'Parque A', widget: ParqueA()),
  (title: 'Parque B', widget: ParqueB()),
];
