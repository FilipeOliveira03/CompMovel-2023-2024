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

      var zona = Zone(produto: responseJSON['produto'], horarioespecifico: responseJSON['horario'], tarifa: responseJSON['tarifa'],);
      print(zona);
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

      // for (var lot in lotsJson){
      //   print(lot.toString());
      // }

      List<Lote> lots =
          lotsJson.map((parquesJson) => Lote.fromMap(parquesJson)).toList();

      return lots;
    } else {
      throw Exception('status code: ${response.statusCode}');
    }
  }



// Future<List<Parque>> getParques() async{
//   final response = await _client.get(
//       url: 'https://emel.city-platform.com/opendata/parking/lots',
//       headers: {
//         'accept': 'application/json',
//         'api_key': '93600bb4e7fee17750ae478c22182dda'
//       });
//
//   if (response.statusCode == 200) {
//
//     final responseJSON = jsonDecode(response.body);
//
//     List parquesJson = responseJSON;
//
//     List<Parque> parques = parquesJson
//         .map((parquesJson) => Parque.fromMap(parquesJson))
//         .toList();
//
//     return parques;
//   } else {
//     throw Exception('status code: ${response.statusCode}');
//   }
// }

// Future<List<Parque>> getParques() async {
//   try {
//     List<Lote> lotsFromApi = await getLots();
//
//     final response = await _client.get(
//         url:
//         'https://emel.city-platform.com/opendata/parking/places',
//         headers: {
//           'accept': 'application/json',
//           'api_key': '93600bb4e7fee17750ae478c22182dda'
//         });
//     if (response.statusCode == 200) {
//       final responseJSON = jsonDecode(response.body);
//       var parquesJson = responseJSON;
//     } else {
//       throw Exception('status code: ${response.statusCode}');
//     }
//
//     List<Parque> listaParques = [];
//
//     return listaParques;
//   } catch (e) {
//     throw Exception('Failed to combine lots: $e');
//   }
// }
}
