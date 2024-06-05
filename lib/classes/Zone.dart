class Zone {
  String produto;
  String horarioespecifico;
  String tarifa;

  Zone({
    required this.produto,
    required this.horarioespecifico,
    required this.tarifa,
  });

  Map<String, dynamic> toDb(String idParque) {
    return {
      'idParque': idParque,
      'produto': produto,
      'horarioespecifico': horarioespecifico,
      'tarifa': tarifa,
    };
  }

  factory Zone.fromDB(Map<String, dynamic> db) {
    return Zone(
        produto: db['produto'],
        horarioespecifico: db['horarioespecifico'],
        tarifa: db['tarifa'],);
  }

}
