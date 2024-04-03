import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../classes/Parque.dart';
import '../pages.dart';

class RegistoIncidentes extends StatefulWidget {
  @override
  _IncidenteFormScreenState createState() => _IncidenteFormScreenState(); //commit
}

class _IncidenteFormScreenState extends State<RegistoIncidentes> {
  String? nomeParque;
  String? tituloCurto;
  int gravidade = 1;
  DateTime data = DateTime.now(); // vem a data atual por defeito
  TextEditingController dataController = TextEditingController();
  String descricaoDetalhada = '';

  final List<String> listaParques = [];


  @override
  void initState() {
    super.initState();
    dataController.text = DateFormat('dd/MM/yyyy HH:mm').format(data);
    for (Parque parque in minhaListaParques.parques) {
      listaParques.add(parque.nome);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: data,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2034),
    );
    if (picked != null && picked != data) {
      setState(() {
        data = picked;
        dataController.text = DateFormat('dd/MM/yyyy HH:mm').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Incidente'),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField(
              value: nomeParque,
              items: listaParques.map((nomeParque) {
                return DropdownMenuItem(
                  value: nomeParque,
                  child: Text(nomeParque),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  nomeParque = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Selecionar Parque',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  tituloCurto = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Título Curto do Incidente',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  gravidade = int.tryParse(value) ?? 1;
                });
              },
              decoration: InputDecoration(
                labelText: 'Gravidade do Incidente (1-5)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: dataController,
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: InputDecoration(
                labelText: 'Data e Hora',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  descricaoDetalhada = value;
                });
              },
              maxLines: null,
              decoration: InputDecoration(
                labelText: 'Descrição Detalhada',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Verificações
                },
                child: Text('Submeter'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
