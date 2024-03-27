import 'dart:ui';

class Incidente{

  DateTime dataHora;
  String descricao;
  int gravidade;
  late Image imagem;

  Incidente(this.dataHora, this.descricao, this.gravidade);
}