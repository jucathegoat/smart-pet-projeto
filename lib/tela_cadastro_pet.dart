import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class TelaCadastroPet extends StatefulWidget {
  const TelaCadastroPet({super.key, required this.cpf});

  final String cpf;

  @override
  State<TelaCadastroPet> createState() => _TelaCadastroPetState();
}

class _TelaCadastroPetState extends State<TelaCadastroPet> {
  final nomeControler = TextEditingController();
  final especieControler = TextEditingController();
  final porteControler = TextEditingController();
  final pesoControler = TextEditingController();
  final nDocumentoControler = TextEditingController();
  final racaControler = TextEditingController();
  final idadeControler = TextEditingController();

  String? erroNome;
  String? erroEspecie;
  String? erroRaca;
  String? erroPorte;
  String? erroPeso;
  String? erroNDocumento;
  String? erroIdade;

  @override
  void dispose() {
    nomeControler.dispose();
    racaControler.dispose();
    idadeControler.dispose();
    especieControler.dispose();
    porteControler.dispose();
    pesoControler.dispose();
    nDocumentoControler.dispose();
    super.dispose();
  }

  Future<void> cadastrarPet() async {
    var url = Uri.parse('http://localhost:8080/cadastrar/pet');
    var resposta = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'cpf': widget.cpf,
        'nome': nomeControler.text,
        'especie': especieControler.text,
        'raca': racaControler.text,
        'porte': porteControler.text,
        'peso': pesoControler.text,
        'n_documento': nDocumentoControler.text,
        'idade': int.parse(idadeControler.text),
      }),
    );

    if (!mounted) return;

    if (resposta.statusCode == 201 || resposta.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Pet cadastrado com sucesso!')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao cadastrar pet')));
    }
  }

  InputDecoration campo({
    required String label,
    required String hint,
    required IconData icon,
    String? erro,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      errorText: erro,
      prefixIcon: Icon(icon, color: const Color.fromARGB(255, 26, 58, 27)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(
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
        title: const Text(
          "Cadastro de Pet",
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
              SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 238, 245, 238),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.pets,
                      size: 36,
                      color: Color.fromARGB(255, 26, 58, 27),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Cadastre seu pet para acompanhar atendimentos, agendamentos e histórico de serviços.",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(
                        controller: nomeControler,
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              erroNome = null;
                            } else if (!RegExp(r'^[A-Za-zÀ-ÿ\s]+$')
                                .hasMatch(value)) {
                              erroNome = 'O nome deve conter apenas letras';
                            } else {
                              erroNome = null;
                            }
                          });
                        },
                        decoration: campo(
                          label: "Nome do Pet",
                          hint: "Digite o nome do pet",
                          icon: Icons.pets,
                          erro: erroNome,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        decoration: campo(
                          label: "Documento",
                          hint: "Número do documento",
                          icon: Icons.badge,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: especieControler,
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              erroEspecie = null;
                            } else if (!RegExp(r'^[A-Za-zÀ-ÿ\s]+$')
                                .hasMatch(value)) {
                              erroEspecie =
                                  'A espécie deve conter apenas letras';
                            } else {
                              erroEspecie = null;
                            }
                          });
                        },
                        decoration: campo(
                          label: "Espécie",
                          hint: "Digite a espécie do seu pet",
                          icon: Icons.category,
                          erro: erroEspecie,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: racaControler,
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              erroRaca = null;
                            } else if (!RegExp(r'^[A-Za-zÀ-ÿ\s]+$')
                                .hasMatch(value)) {
                              erroRaca = 'A raça deve conter apenas letras';
                            } else {
                              erroRaca = null;
                            }
                          });
                        },
                        decoration: campo(
                          label: "Raça",
                          hint: "Digite a raça do seu pet",
                          icon: Icons.pets,
                          erro: erroRaca,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: porteControler,
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              erroPorte = null;
                            } else if (!RegExp(r'^[A-Za-zÀ-ÿ\s]+$')
                                .hasMatch(value)) {
                              erroPorte = 'O porte deve conter apenas letras';
                            } else {
                              erroPorte = null;
                            }
                          });
                        },
                        decoration: campo(
                          label: "Porte",
                          hint: "Digite o porte do seu pet",
                          icon: Icons.straighten,
                          erro: erroPorte,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: pesoControler,
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              erroPeso = null;
                            } else if (!RegExp(r'^\d+(\.\d+)?$')
                                .hasMatch(value)) {
                              erroPeso = 'O peso deve ser um número válido';
                            } else {
                              erroPeso = null;
                            }
                          });
                        },
                        decoration: campo(
                          label: "Peso",
                          hint: "Ex: 8.5 kg",
                          icon: Icons.monitor_weight,
                          erro: erroPeso,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: idadeControler,
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              erroIdade = null;
                            } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                              erroIdade = 'A idade deve ser um número inteiro';
                            } else {
                              erroIdade = null;
                            }
                          });
                        },
                        keyboardType: TextInputType.number,
                        decoration: campo(
                          label: "Idade",
                          hint: "Ex: 3 anos",
                          icon: Icons.cake,
                          erro: erroIdade,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await cadastrarPet();

                        if (!mounted) return;

                        Navigator.pop(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 26, 58, 27),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.save),
                      label: const Text("Cadastrar"),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Voltar"),
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
