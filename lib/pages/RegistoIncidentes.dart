import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../classes/Incidente.dart';
import '../classes/Parque.dart';
import '../main_page.dart';
import '../pages.dart';

class RegistoIncidentes extends StatefulWidget {
  @override
  _IncidenteFormScreenState createState() => _IncidenteFormScreenState();
}

class _IncidenteFormScreenState extends State<RegistoIncidentes> {
  final _formKey = GlobalKey<FormState>();
  XFile? _imageFile;

  String? nomeParque;
  String? tituloCurto;
  double gravidade = 1;
  DateTime data = DateTime.now();
  TextEditingController descricaoController = TextEditingController();
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
    Parque? parqueSelecionado = minhaListaParques.parques.firstWhere(
          (parque) => parque.nome == nomeParque,
    );

    if (parqueSelecionado != null) {
      parqueSelecionado.incidentes.add(incidente);
      minhaListaIncidentes.incidentes.add(incidente);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
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
        title: Text('Formulário de Incidentes'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Campos com * são obrigatórios',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
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
                    labelText: 'Selecionar Parque *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo é obrigatório';
                    }
                    return null;
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      tituloCurto = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Título Curto do Incidente *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo é obrigatório';
                    }
                    return null;
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                TextFormField(
                  controller: descricaoController,
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt),
                        SizedBox(width: 8.0),
                        Text('Selecionar Imagem'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.01,
                          left: MediaQuery.of(context).size.width * 0.05,
                          right: MediaQuery.of(context).size.width * 0.05,
                        ),
                        child: Text(
                          'Gravidade do incidente: *',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SfSlider(
                        value: gravidade,
                        min: 1,
                        max: 5,
                        stepSize: 1,
                        interval: 1,
                        showTicks: true,
                        showLabels: true,
                        minorTicksPerInterval: 1,
                        onChanged: (value) {
                          setState(() {
                            gravidade = value;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
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
                        initialTime: TimeOfDay.fromDateTime(
                            currentValue ?? DateTime.now()),
                      );
                      return DateTimeField.combine(date, time);
                    } else {
                      return currentValue;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Data e Hora *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Este campo é obrigatório';
                    }
                    return null;
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Incidente novoIncidente = Incidente(
                          nomeParque!,
                          tituloCurto!,
                          data,
                          descricaoDetalhada,
                          gravidade.toInt(),
                          _imageFile,
                        );

                        adicionarIncidenteAoParqueSelecionado(novoIncidente);

                        _formKey.currentState!.reset();

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
      ),
    );
  }
}
