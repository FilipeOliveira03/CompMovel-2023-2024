import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../classes/Incidente.dart';
import '../classes/Lote.dart';

class ParquesDatabase {
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

  Future<List<Lote>> getZonas() async {
    if (_database == null) {
      throw Exception('DB not initialized');
    }

    List result = await _database!.rawQuery("SELECT * FROM Lote");

    return result.map((entry) => Lote.fromDB(entry)).toList();
  }

  Future<void> insertIncidente (Incidente incidente) async {

    if(_database == null){
      throw Exception('DB not initialized');
    }

    await _database!.insert('Incidente', incidente.toDb());

  }

  Future<List<Incidente>> getIncidentes(String idParque) async {
    if (_database == null) {
      throw Exception('DB not initialized');
    }

    List result = await _database!.rawQuery("SELECT * FROM Incidente WHERE idParque = '$idParque'");

    return result.map((entry) => Incidente.fromDB(entry)).toList();
  }

}
