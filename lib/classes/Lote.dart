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

  Lote({
    required this.id,
    required this.nome,
    required this.lotAtual,
    required this.lotMaxima,
    required this.dataAtualizacao,
    required this.latitude,
    required this.longitude,
    required this.tipoParque,
    this.assertImagem,
  });

  Map<String, dynamic> toDb() {
    return {
      'id': id,
      'nome': nome,
      'lotAtual': lotAtual,
      'lotMaxima': lotMaxima,
      'dataAtualizacao': dataAtualizacao,
      'latitude': latitude,
      'longitude': longitude,
      'tipoParque': tipoParque,
      'assertImagem': 'assets/ImagensParques/$id.png',
    };
  }

  factory Lote.fromJSON(Map<String, dynamic> map) {
    return Lote(
      id: map['id_parque'],
      nome: map['nome'],
      lotAtual: map['ocupacao'],
      lotMaxima: map['capacidade_max'],
      dataAtualizacao: map['data_ocupacao'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      tipoParque: map['tipo'],
      assertImagem: 'assets/ImagensParques/${map['id_parque']}.png',
    );
  }

  factory Lote.fromDB(Map<String, dynamic> db) {
    return Lote(
      id: db['id'],
      nome: db['nome'],
      lotAtual: db['lotAtual'],
      lotMaxima: db['lotMaxima'],
      dataAtualizacao: db['dataAtualizacao'],
      latitude: db['latitude'],
      longitude: db['longitude'],
      tipoParque: db['tipoParque'],
      assertImagem: 'assets/ImagensParques/${db['id']}.png',
    );
  }
}
