import 'package:flutter/material.dart';

import 'classes/Incidente.dart';
import 'pages/Dashboard.dart';
import 'pages/ListaParques.dart';
import 'pages/Mapa.dart';
import 'pages/RegistoIncidentes.dart';


final ListaIncidente minhaListaIncidentes = ListaIncidente();

final pages = [
  (title: 'Home', icon: Icons.home, widget: Dashboard()),
  (title: 'Parques', icon: Icons.list, widget: ListaParques()),
  (title: 'Mapa', icon: Icons.map, widget: Mapa()),
  (title: 'Incidentes', icon: Icons.warning, widget: RegistoIncidentes()),
];

