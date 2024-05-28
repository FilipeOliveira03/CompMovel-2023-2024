import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:proj_comp_movel/http/http_client.dart';

import 'Lote.dart';
import 'Parque.dart';
import 'Zone.dart';

class ParquesRepository {
  final HttpClient _client;

  ParquesRepository({required HttpClient client}) : _client = client;

  Future<Zone> getPlaces(String id) async {
    id = id.split('P')[1];

    final response = await _client.get(
        url: 'https://emel.city-platform.com/opendata/parking/zone/$id',
        headers: {
          'accept': 'application/json',
          'api_key': '93600bb4e7fee17750ae478c22182dda'
        });

    if (response.statusCode == 200) {
      final responseJSON = jsonDecode(response.body);

      var zona = Zone(
        produto: responseJSON['produto'],
        horarioespecifico: responseJSON['horario'],
        tarifa: responseJSON['tarifa'],
      );
      return zona;
    } else {
      throw Exception('status code: ${response.statusCode}');
    }
  }

  Future<List<Lote>> getLots() async {
    final response = await _client.get(
        url: 'https://emel.city-platform.com/opendata/parking/lots',
        headers: {
          'accept': 'application/json',
          'api_key': '93600bb4e7fee17750ae478c22182dda'
        });

    if (response.statusCode == 200) {
      final responseJSON = jsonDecode(response.body);

      List lotsJson = responseJSON;


      List<Lote> lots =
          lotsJson.map((parquesJson) => Lote.fromJSON(parquesJson)).toList();

      return lots;
    } else {
      throw Exception('status code: ${response.statusCode}');
    }
  }
}
