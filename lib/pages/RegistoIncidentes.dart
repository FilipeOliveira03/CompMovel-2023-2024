import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../classes/Incidente.dart';
import '../classes/Lote.dart';
import '../classes/Parque.dart';
import '../classes/ParquesRepository.dart';
import '../main_page.dart';
import '../pages.dart';

class RegistoIncidentes extends StatefulWidget {
  final String? initialParque;

  RegistoIncidentes({super.key, this.initialParque});

  @override
  IncidenteFormScreenState createState() => IncidenteFormScreenState();
}

class IncidenteFormScreenState extends State<RegistoIncidentes> {
  final _formKey = GlobalKey<FormState>();
  XFile? _imageFile;

  String? nomeParque;
  String? tituloCurto;
  double gravidade = 1;
  DateTime data = DateTime.now();
  TextEditingController descricaoController = TextEditingController();
  String descricaoDetalhada = '';

  final List<String> listaParques = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Obtém a lista de parques do repositório
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final minhaListaParques = await context.read<ParquesRepository>().getLots();
      setState(() {
        for (Lote lote in minhaListaParques) {
          listaParques.add(lote.nome);
        }
        isLoading = false;
      });
    });
  }

  void adicionarIncidenteAoParqueSelecionado(var minhaListaParques, Incidente incidente) {
    Parque? parqueSelecionado = minhaListaParques.firstWhere(
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

  void _exibirPopUp(var minhaListaParques) {
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
                  MaterialPageRoute(builder: (context) => MainPage(minhaListaParques: minhaListaParques,)),
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
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Formulário de Incidentes'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
                buildSelecionarParqueDropdown(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                buildDescricaoCurtaText(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                buildDescricaoDetalhadaText(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                buildSelecionarImagem(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                buildGravidadeIncidente(context),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                buildDataHora(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                buildValidacaoFormulario(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Center buildValidacaoFormulario() {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final minhaListaParques = await context.read<ParquesRepository>().getLots();

            // Verifica se _imageFile é nulo e cria o objeto Incidente de acordo
            Incidente novoIncidente;
            if (_imageFile != null) {
              novoIncidente = Incidente(
                nomeParque!,
                tituloCurto!,
                data,
                descricaoDetalhada,
                gravidade.toInt(),
                _imageFile!,
              );
            } else {
              novoIncidente = Incidente(
                nomeParque!,
                tituloCurto!,
                data,
                descricaoDetalhada,
                gravidade.toInt(),
                null, // ou outro valor que indique que não há imagem
              );
            }

            adicionarIncidenteAoParqueSelecionado(minhaListaParques, novoIncidente);

            _formKey.currentState!.reset();

            _exibirPopUp(minhaListaParques);
          }
        },
        child: Text('Submeter'),
      ),
    );
  }

  DateTimeField buildDataHora() {
    return DateTimeField(
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
        labelText: 'Data e Hora *',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null) {
          return 'Este campo é obrigatório';
        }
        return null;
      },
    );
  }

  Container buildGravidadeIncidente(BuildContext context) {
    return Container(
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
    );
  }

  GestureDetector buildSelecionarImagem() {
    return GestureDetector(
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
    );
  }

  TextFormField buildDescricaoDetalhadaText() {
    return TextFormField(
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
    );
  }

  TextFormField buildDescricaoCurtaText() {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          tituloCurto = value;
        });
      },
      decoration: InputDecoration(
        labelText: 'Descrição Curta do Incidente *',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Este campo é obrigatório';
        }
        return null;
      },
    );
  }

  DropdownButtonFormField<String> buildSelecionarParqueDropdown() {
    return DropdownButtonFormField(
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
    );
  }
}
