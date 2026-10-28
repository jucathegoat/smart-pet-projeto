import 'package:flutter/material.dart';
import 'package:flutter_application_1/tela_agendamento.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class TelaNovoAgendamento extends StatefulWidget {
  const TelaNovoAgendamento({super.key, required this.cpf});

  final String cpf;


  @override
  State<TelaNovoAgendamento> createState() => _TelaNovoAgendamentoState();
}

class _TelaNovoAgendamentoState extends State<TelaNovoAgendamento> {
  String? servicoSelecionado;
  String? petSelecionado;
  final petController = TextEditingController();
  final dataController = TextEditingController();
  final horaController = TextEditingController();
  List<dynamic> listaServicos = [];
  List<dynamic> listaPets = [];

  final String baseUrl = 'http://localhost:8080';

  @override
  void initState() {
    super.initState();
    listarServicos();
    listarPets();
  }

  Future<void> listarServicos() async {
    try {
      final resposta = await http.get(Uri.parse('$baseUrl/servicos'));
      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);
        setState(() {
          listaServicos = dados['servicos'] ?? [];
        });
      }
    } catch (e) {
      print("Erro ao carregar serviços: $e");
    }
  }

  Future<void> salvarAgendamento() async {
    if (servicoSelecionado == null ||
        petSelecionado!.isEmpty ||
        dataController.text.isEmpty ||
        horaController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Preencha todos os campos!")));
      return;
    }

    final agendamento = {
      "cpf": widget.cpf,
      "servico": int.parse(servicoSelecionado!),
      "pet": int.parse(petSelecionado!),
      "data": dataController.text,
      "hora": horaController.text,
    };

    try {
      final resposta = await http.post(
        Uri.parse('$baseUrl/novo/agendamento'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(agendamento),
      );

      if (resposta.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Agendamento realizado com sucesso!")),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Erro ao salvar agendamento.")));
      }
    } catch (e) {
      print("Erro: $e");
    }
  }

  Future<void> selecionarData() async {
    DateTime? dataEscolhida = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (dataEscolhida != null) {
      setState(() {
        dataController.text =
            "${dataEscolhida.year}-${dataEscolhida.month}-${dataEscolhida.day}";
      });
    }
  }

  Future<void> selecionarHora() async {
    TimeOfDay? horaEscolhida = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (horaEscolhida != null) {
      setState(() {
        horaController.text =
            "${horaEscolhida.hour.toString().padLeft(2, '0')}:${horaEscolhida.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> listarPets() async {
    try {
      final resposta = await http.get(Uri.parse('${baseUrl}/tutor/${widget.cpf}/pets'));
      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);
        setState(() {
          listaPets =  dados['pets'] ?? [];
        });
      }
    } catch (e) {
      print("Erro ao carregar serviços: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Novo Agendamento",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 249, 243, 243),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(34),
          child: Column(
            children: [
              SizedBox(height: 30),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Serviço",
                ),
                items: listaServicos.map<DropdownMenuItem<String>>((servico) {
                  return DropdownMenuItem<String>(
                    value: servico['codigoServico'].toString(), // valor interno
                    child: Text(servico['especialidade']), // texto exibido
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    servicoSelecionado = value;
                  });
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Pet",
                ),
                items: listaPets.map<DropdownMenuItem<String>>((pets) {
                  return DropdownMenuItem<String>(
                    value: pets['codigoPet'].toString(),
                    child: Text(pets['nome']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    petSelecionado = value;
                  });
                },
              ),
              SizedBox(height: 10),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Data",
                  hintText: "Selecione a data",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                controller: dataController,
                onTap: selecionarData,
              ),
              SizedBox(height: 10),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Hora",
                  hintText: "Selecione a hora",
                  suffixIcon: Icon(Icons.access_time),
                ),
                controller: horaController,
                onTap: selecionarHora,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(
                        Color.fromARGB(255, 26, 58, 27),
                      ),
                    ),
                    onPressed: () async{
                     await salvarAgendamento();
                      Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => TelaAgendamento(cpf: widget.cpf,)));
                    
                    },
                    child: Text("Agendar"),
                  ),
                  SizedBox(width: 10),
                  FilledButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(
                        Color.fromARGB(255, 228, 230, 228),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancelar",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
