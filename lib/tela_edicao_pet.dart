import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class TelaEdicaoPet extends StatefulWidget {
  const TelaEdicaoPet({super.key, required this.codigoPet, required this.nDocumento, required this.peso, required this.idade});

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
    var url = Uri.parse('http://localhost:8080/atualizar/pet');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              TextField(
                controller: nDocumentoControler,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Nº Documento",
                  hintText: "Digite o nº Documento do seu pet",
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: pesoControler,
                onChanged: (value){
                  setState(() {
                    if (value.isEmpty) {
                      erroPeso = null;
                    } else if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
                      erroPeso = 'O peso deve ser um número válido';
                    } else {
                      erroPeso = null;
                    }
                  }); 
                },                
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Peso",
                  hintText: "Digite o peso do seu pet",
                  errorText: erroPeso,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: idadeControler,
                onChanged: (value){
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
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Idade",
                  hintText: "Digite a idade do seu pet",
                  errorText: erroIdade,
                ),
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
                    onPressed: () async {
                      await atualizarPet();
                      Navigator.pop(context);
                    },
                    child: const Text("Atualizar"),
                  ),
                  SizedBox(width: 10),
                  FilledButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(
                        Color.fromARGB(255, 228, 230, 228),
                      ),
                    ),
                    onPressed: () {
                      // Lógica para voltar à tela anterior
                      Navigator.pop(context);
                    },
                    child: const Text("Voltar"),
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
