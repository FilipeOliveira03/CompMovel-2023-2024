import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import '../classes/Incidente.dart';
import '../classes/Parque.dart';
import '../main_page.dart';
import '../pages.dart';

class RegistoIncidentes extends StatefulWidget {
  @override
  _IncidenteFormScreenState createState() => _IncidenteFormScreenState();
}

class _IncidenteFormScreenState extends State<RegistoIncidentes> {
  final _formKey = GlobalKey<FormState>(); // Chave global para o formulário

  String? nomeParque;
  String? tituloCurto;
  int gravidade = 1;
  DateTime data = DateTime.now(); // vem a data atual por defeito
  TextEditingController descricaoController = TextEditingController(); // Alteração aqui
  String descricaoDetalhada = '';

  final List<String> listaParques = [];

  @override
  void initState() {
    super.initState();
    for (Parque parque in minhaListaParques.parques) {
      listaParques.add(parque.nome);
    }
  }

  void adicionarIncidenteAoParqueSelecionado(Incidente incidente) {
    // Procurar o parque selecionado na lista de parques
    Parque? parqueSelecionado = minhaListaParques.parques.firstWhere(
          (parque) => parque.nome == nomeParque,
    );

    if (parqueSelecionado != null) {
      // Adicionar o incidente à lista de incidentes do parque selecionado
      parqueSelecionado.incidentes.add(incidente);
    }
  }

  void _exibirPopUp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sucesso'),
          content: Text('O formulário foi submetido com sucesso!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                      (route) => false,
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Incidente'),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Form(
          key: _formKey, // Atribuindo a chave global ao formulário
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
                  labelText: 'Selecionar Parque *', // Adicionando asterisco
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo é obrigatório'; // Mensagem de erro para campo vazio
                  }
                  return null; // Retorna nulo se a validação passar
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    tituloCurto = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Título Curto do Incidente *', // Adicionando asterisco
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo é obrigatório'; // Mensagem de erro para campo vazio
                  }
                  return null; // Retorna nulo se a validação passar
                },
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
                  labelText: 'Gravidade do Incidente (1-5) *', // Adicionando asterisco
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo é obrigatório'; // Mensagem de erro para campo vazio
                  }
                  final gravidadeValue = int.tryParse(value);
                  if (gravidadeValue == null || gravidadeValue < 1 || gravidadeValue > 5) {
                    return 'A gravidade deve estar entre 1 e 5'; // Mensagem de erro para valor inválido
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              DateTimeField(
                format: DateFormat("dd/MM/yyyy HH:mm"),
                initialValue: data,
                onChanged: (value) {
                  setState(() {
                    data = value!;
                  });
                },
                onShowPicker: (context, currentValue) async {
                  final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2015, 8),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2034),
                  );
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.combine(date, time);
                  } else {
                    return currentValue;
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Data e Hora *', // Adicionando asterisco
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Este campo é obrigatório'; // Mensagem de erro para campo vazio
                  }
                  return null; // Retorna nulo se a validação passar
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: descricaoController, // Alteração aqui
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
                    // Verificar se o formulário é válido antes de submeter
                    if (_formKey.currentState!.validate()) {
                      // Criar um novo incidente com os dados do formulário
                      Incidente novoIncidente = Incidente(
                        nomeParque!,
                        tituloCurto!,
                        data,
                        descricaoDetalhada,
                        gravidade,
                        null, // Defina aqui a imagem do incidente, se aplicável
                      );

                      // Adicionar o incidente à lista de incidentes do parque selecionado
                      adicionarIncidenteAoParqueSelecionado(novoIncidente);

                      // Limpar o formulário após a submissão
                      _formKey.currentState!.reset();

                      // Exibir o pop-up de sucesso
                      _exibirPopUp();
                    }
                  },
                  child: Text('Submeter'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
