class Zone {
  String produto;
  String horarioespecifico;
  String tarifa;

  Zone({
    required this.produto,
    required this.horarioespecifico,
    required this.tarifa,
  });

  factory Zone.fromDB(Map<String, dynamic> db) {
    return Zone(
        produto: db['produto'],
        horarioespecifico: db['horarioespecifico'],
        tarifa: db['tarifa'],);
  }

}
