import 'dart:async';

import 'package:intl/intl.dart';
import 'package:proj_comp_movel/classes/Zone.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../classes/Incidente.dart';
import '../classes/Lote.dart';
import '../repository/IParquesRepository.dart';

class ParquesDatabase extends IParquesRepository {
  Database? _database;

  Future<void> init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'parques.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE Lote(
            id TEXT PRIMARY KEY,
            nome TEXT NOT NULL,
            lotAtual INTEGER NOT NULL,
            lotMaxima INTEGER NOT NULL,
            dataAtualizacao TEXT NOT NULL,
            latitude TEXT NOT NULL,
            longitude TEXT NOT NULL,
            tipoParque TEXT NOT NULL,
            assertImagem TEXT NULL
          )
          ''');
        await db.execute('''
           CREATE TABLE Zone(
            idParque TEXT NOT NULL,
            produto TEXT NOT NULL,
            horarioespecifico TEXT NOT NULL,
            tarifa TEXT NOT NULL
          )
        ''');
        await db.execute('''
           CREATE TABLE Incidente(
            idParque TEXT NOT NULL,
            nomeParque TEXT NOT NULL,
            tituloCurto TEXT NOT NULL,
            data TEXT NOT NULL,
            descricaoDetalhada TEXT NULL,
            gravidade INTEGER NOT NULL
          )
        ''');

      },

      version: 1,
    );
  }

  Future<List<Lote>> getLots() async {
    if (_database == null) {
      throw Exception('DB not initialized');
    }

    List result = await _database!.rawQuery("SELECT * FROM Lote");

    return result.map((entry) => Lote.fromDB(entry)).toList();
  }


  Future<Zone> getZones(String idParque) async {
    if (_database == null) {
      throw Exception('DB not initialized');
    }

    List result = await _database!.rawQuery("SELECT * FROM Zone WHERE idParque = '$idParque'");

    return result.map((entry) => Zone.fromDB(entry)).first;
  }

  Future<List<Incidente>> getIncidentes(String idParque) async {
    if (_database == null) {
      throw Exception('DB not initialized');
    }

    List result = await _database!.rawQuery("SELECT * FROM Incidente WHERE idParque = '$idParque'");

    return result.map((entry) => Incidente.fromDB(entry)).toList();
  }

  Future<List<Incidente>> getIncidentesRecentes() async {
    if (_database == null) {
      throw Exception('DB not initialized');
    }

    DateTime hoje = DateTime.now();
    String dataFormatada = '${hoje.year}-${hoje.month.toString().padLeft(2, '0')}-${hoje.day.toString().padLeft(2, '0')}';
    // print(dataFormatada);

    List result = await _database!.rawQuery("SELECT * FROM Incidente WHERE DATE(data) = '$dataFormatada'");

    return result.map((entry) => Incidente.fromDB(entry)).toList();
  }

  Future<void> insertIncidente (Incidente incidente) async {

    if(_database == null){
      throw Exception('DB not initialized');
    }

    await _database!.insert('Incidente', incidente.toDb());

  }

  Future<void> insertLote(Lote lote) async{
    if(_database == null){
      throw Exception('DB not initialized');
    }

    await _database!.insert('Lote', lote.toDb());
  }

  Future<void> insertZone(Zone zone, String idParque) async{
    if(_database == null){
      throw Exception('DB not initialized');
    }

    await _database!.insert('Zone', zone.toDb(idParque));
  }

  Future<void> deleteAllLote() async{
    if (_database == null) {
      throw Exception('DB not initialized');
    }

    await _database!.rawDelete('DELETE FROM Lote');
  }

  Future<void> deleteAllZone() async{
    if (_database == null) {
      throw Exception('DB not initialized');
    }

    await _database!.rawDelete('DELETE FROM Zone');
  }




}
