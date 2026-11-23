import 'package:flutter/material.dart';

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
  bool salvando = false;
  final String baseUrl = 'http://localhost:8080';

  @override
  void initState() {
    super.initState();
    listarServicos();
    listarPets();
  }

  Future<void> listarServicos() async {
    try {
      final resposta = await http.get(Uri.parse('$baseUrl/api/servicos'));
      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);

        if (!mounted) return;

        setState(() {
          listaServicos = dados['servicos'] ?? [];
        });
      }
    } catch (e) {
      print("Erro ao carregar serviços: $e");
    }
  }

  Future<bool> salvarAgendamento() async {
    if (servicoSelecionado == null ||
        petSelecionado == null ||
        dataController.text.isEmpty ||
        horaController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Preencha todos os campos")));
      return false;
    }

    int idPet = int.tryParse(petSelecionado ?? '') ?? 1;
    int idServico = int.tryParse(servicoSelecionado ?? '') ?? 1;

    // Busca o nome do pet e servico selecionados
    String nomePet = 'Pet';
    for (var p in listaPets) {
      if ((p['id'] ?? p['codigo_pet'])?.toString() == petSelecionado) {
        nomePet = p['nome']?.toString() ?? 'Pet';
        break;
      }
    }

    String nomeServico = 'Atendimento Geral';
    for (var s in listaServicos) {
      if ((s['codigo'] ?? s['codigo_servico'] ?? s['id'])?.toString() == servicoSelecionado) {
        nomeServico = s['nome']?.toString() ?? 'Atendimento Geral';
        break;
      }
    }

    try {
      final resposta = await http.post(
        Uri.parse('$baseUrl/api/fila/adicionar'),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: jsonEncode({
          "cpf": widget.cpf.replaceAll(RegExp(r'[^0-9]'), ''),
          "cliente": widget.cpf,
          "pet": nomePet,
          "servico": nomeServico,
          "idPet": idPet.toString(),
          "idServico": idServico.toString(),
        }),
      );

      if (resposta.statusCode == 200 || resposta.statusCode == 201) {
        return true;
      }

      return false;
    } catch (_) {
      return false;
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
      final resposta = await http.get(
        Uri.parse('${baseUrl}/tutor/${widget.cpf}/pets'),
      );
      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);

        if (!mounted) return;

        setState(() {
          listaPets = dados['pets'] ?? [];
        });
      }
    } catch (e) {
      print("Erro ao carregar pets: $e");
    }
  }

  InputDecoration _decoracaoCampo({
    required String label,
    required IconData icone,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icone, color: const Color.fromARGB(255, 26, 58, 27)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 26, 58, 27),
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 249, 243, 243),
        title: const Text(
          "Novo Agendamento",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(34),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 238, 245, 238),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: Color.fromARGB(255, 26, 58, 27),
                      size: 32,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Escolha o pet, o serviço, a data e o horário para realizar o agendamento.",
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: servicoSelecionado,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          labelText: "Serviço",
                          prefixIcon: const Icon(Icons.medical_services),
                        ),
                        items: listaServicos.map<DropdownMenuItem<String>>((
                          servico,
                        ) {
                          return DropdownMenuItem<String>(
                            value: servico['codigo'].toString(),
                            child: Text(servico['nome']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            servicoSelecionado = value;
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        value: petSelecionado,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          labelText: "Pet",
                          prefixIcon: const Icon(Icons.pets),
                        ),
                        items: listaPets.map<DropdownMenuItem<String>>((pet) {
                          return DropdownMenuItem<String>(
                            value: pet['id'].toString(),
                            child: Text(pet['nome']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            petSelecionado = value;
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      TextField(
                        controller: dataController,
                        readOnly: true,
                        onTap: selecionarData,
                        decoration: InputDecoration(
                          labelText: "Data",
                          prefixIcon: const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextField(
                        controller: horaController,
                        readOnly: true,
                        onTap: selecionarHora,
                        decoration: InputDecoration(
                          labelText: "Horário",
                          prefixIcon: const Icon(Icons.access_time),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 160,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 26, 58, 27),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: salvando
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.check_circle),
                      label: Text(salvando ? "Salvando..." : "Agendar"),
                      onPressed: salvando
                          ? null
                          : () async {
                              setState(() {
                                salvando = true;
                              });

                              final sucesso = await salvarAgendamento();

                              if (!mounted) return;

                              setState(() {
                                salvando = false;
                              });

                              if (sucesso) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Agendamento criado com sucesso!",
                                    ),
                                  ),
                                );

                                Navigator.pop(context, true);
                              }
                            },
                    ),
                  ),

                  const SizedBox(width: 12),

                  SizedBox(
                    width: 120,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancelar"),
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
