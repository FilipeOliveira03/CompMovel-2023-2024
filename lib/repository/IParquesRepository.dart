import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:proj_comp_movel/http/http_client.dart';

import '../classes/Lote.dart';
import '../classes/Zone.dart';



abstract class IParquesRepository {
  Future<List<Lote>> getLots();
  Future<Zone> getZones(String idParque);
  Future<void> insertLote(Lote lote);
  Future<void> insertZone(Zone zone, String idParque);
  Future<void> deleteAllLote();
  Future<void> deleteAllZone();
}
