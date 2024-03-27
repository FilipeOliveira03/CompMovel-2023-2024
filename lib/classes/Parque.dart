import 'package:proj_comp_movel/classes/Incidente.dart';

enum TIPOPARQUE{
  ESTRUTURA,
  SUPERFICIE,
}

class Parque{

  String nome;
  int lotAtual = 0;
  int lotMaxima;
  TIPOPARQUE tipoParque;
  DateTime horarioFuncionamento;
  String morada;
  List<Incidente> incidentes = [];

  Parque(this.nome, this.tipoParque, this.lotMaxima , this.horarioFuncionamento, this.morada);

}