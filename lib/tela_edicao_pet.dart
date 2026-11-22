import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class TelaEdicaoPet extends StatefulWidget {
  const TelaEdicaoPet({
    super.key,
    required this.codigoPet,
    required this.nDocumento,
    required this.peso,
    required this.idade,
  });

  final int codigoPet;
  final String nDocumento;
  final double peso;
  final int idade;

  @override
  State<TelaEdicaoPet> createState() => _TelaEdicaoPetState();
}

class _TelaEdicaoPetState extends State<TelaEdicaoPet> {
  final pesoControler = TextEditingController();
  final nDocumentoControler = TextEditingController();
  final idadeControler = TextEditingController();

  @override
  void initState() {
    super.initState();
    nDocumentoControler.text = widget.nDocumento;
    pesoControler.text = widget.peso.toString();
    idadeControler.text = widget.idade.toString();
  }

  String? erroPeso;
  String? erroIdade;

  @override
  void dispose() {
    idadeControler.dispose();
    pesoControler.dispose();
    nDocumentoControler.dispose();
    super.dispose();
  }

  Future<void> atualizarPet() async {
    var url = Uri.parse('http://localhost:8080/api/pets/${widget.codigoPet}');
    var resposta = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'codigoPet': widget.codigoPet,
        'peso': pesoControler.text,
        'n_documento': nDocumentoControler.text,
        'idade': int.parse(idadeControler.text),
      }),
    );

    if (!mounted) return;

    if (resposta.statusCode == 201 || resposta.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Pet atualizado com sucesso!')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao atualizar pet')));
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
          "Edição de Pet",
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
                        "Edite as informações do seu pet abaixo. ",
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
                        controller: nDocumentoControler,
                        decoration: campo(
                          label: "Documento",
                          hint: "Número do documento",
                          icon: Icons.badge,
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
                        await atualizarPet();

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
                      label: const Text("Atualizar"),
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
