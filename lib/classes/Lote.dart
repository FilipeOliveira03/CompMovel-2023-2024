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

  factory Lote.fromMap(Map<String, dynamic> map){
    return Lote(id: map['id_parque'], nome: map['nome'], lotAtual: map['ocupacao'], lotMaxima: map['capacidade_max'], dataAtualizacao: map['data_ocupacao'], latitude: map['latitude'], longitude: map['longitude'], tipoParque: map['tipo']);
  }


}
