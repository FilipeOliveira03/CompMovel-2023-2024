import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:proj_comp_movel/http/http_client.dart';
import 'package:proj_comp_movel/services/connectivity_service.dart';

import '../classes/Lote.dart';
import '../classes/Zone.dart';
import 'IParquesRepository.dart';

class ParquesRepository {
  IParquesRepository local;
  IParquesRepository remote;
  ConnectivityService connectivityService;
  bool _isOnlineInitialized = false;

  ParquesRepository(
      {required this.local,
      required this.remote,
      required this.connectivityService});

  Future<List<Lote>> getLots() async {
    if (await connectivityService.isOnline()) {
      var lots = await remote.getLots();

      local.deleteAllLote().then((_) {
        for (var lote in lots) {
          local.insertLote(lote);
        }
      });

      return lots;
    } else {
      return await local.getLots();
    }
  }

  Future<Zone> getZones(String idParque) async {
    if (await connectivityService.isOnline()) {
      if (!_isOnlineInitialized) {
        await local.deleteAllZone();
        _isOnlineInitialized = true;
      }

      var zone = await remote.getZones(idParque);
      local.insertZone(zone, idParque);
      return zone;
    } else {
      return await local.getZones(idParque);
    }
  }
}
