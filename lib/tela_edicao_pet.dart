import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class TelaEdicaoPet extends StatefulWidget {
  const TelaEdicaoPet({super.key, required this.codigoPet});

  final int codigoPet;

  @override
  State<TelaEdicaoPet> createState() => _TelaEdicaoPetState();
}

class _TelaEdicaoPetState extends State<TelaEdicaoPet> {
  final pesoControler = TextEditingController();
  final nDocumentoControler = TextEditingController();
  final idadeControler = TextEditingController();

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
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Peso",
                  hintText: "Digite o peso do seu pet",
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: idadeControler,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Idade",
                  hintText: "Digite a idade do seu pet",
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
