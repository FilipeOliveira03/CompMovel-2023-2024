import 'Incidente.dart';

class Lote {
  String id;
  String nome;
  int lotAtual;
  int lotMaxima;
  String dataAtualizacao;
  String latitude;
  String longitude;
  String tipoParque;
  double? distancia;
  String? assertImagem;
  List<Incidente> incidentes = [];

  Lote({
    required this.id,
    required this.nome,
    required this.lotAtual,
    required this.lotMaxima,
    required this.dataAtualizacao,
    required this.latitude,
    required this.longitude,
    required this.tipoParque,
  });

  factory Lote.fromJSON(Map<String, dynamic> map) {
    return Lote(
        id: map['id_parque'],
        nome: map['nome'],
        lotAtual: map['ocupacao'],
        lotMaxima: map['capacidade_max'],
        dataAtualizacao: map['data_ocupacao'],
        latitude: map['latitude'],
        longitude: map['longitude'],
        tipoParque: map['tipo']);
  }

  factory Lote.fromDB(Map<String, dynamic> db) {
    return Lote(
        id: db['id_parque'],
        nome: db['nome'],
        lotAtual: db['ocupacao'],
        lotMaxima: db['capacidade_max'],
        dataAtualizacao: db['data_ocupacao'],
        latitude: db['latitude'],
        longitude: db['longitude'],
        tipoParque: db['tipo']);
  }
}
