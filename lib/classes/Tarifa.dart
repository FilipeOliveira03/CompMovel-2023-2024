class Tarifa {
  String cor;
  double preco;
  int duracaoMax;

  Tarifa({
    required this.cor,
    required this.preco,
    required this.duracaoMax,
  });
}
class Tarifas{
  List<Tarifa> tarifas = [
    Tarifa(cor: 'Verde', preco: 0.8, duracaoMax: 4),
    Tarifa(cor: 'Amarela', preco: 1.2, duracaoMax: 4),
    Tarifa(cor: 'Vermelha', preco: 1.6, duracaoMax: 2),
    Tarifa(cor: 'Castanha', preco: 2.0, duracaoMax: 2),
    Tarifa(cor: 'Preta', preco: 3.0, duracaoMax: 2),
  ];
}
