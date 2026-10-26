import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'tela_pets.dart';

import 'dart:convert';

class TelaCadastroPet extends StatefulWidget {
  const TelaCadastroPet({super.key, required this.cpf});

  final String cpf;

  @override
  State<TelaCadastroPet> createState() => _TelaCadastroPetState();
}

class _TelaCadastroPetState extends State<TelaCadastroPet> {

  final nomeControler = TextEditingController();
  final racaControler = TextEditingController();
  final idadeControler = TextEditingController();

  @override
  void dispose() {
    nomeControler.dispose();
    racaControler.dispose();
    idadeControler.dispose();
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
        'especie': racaControler.text,
        'idade': int.parse(idadeControler.text)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              TextField(
                controller: nomeControler,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Nome do Pet",
                  hintText: "Digite o nome do seu pet",
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: racaControler,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Espécie",
                  hintText: "Digite a espécie do seu pet",
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
                    onPressed: () {
                      cadastrarPet();
                      Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => TelaPets(cpf: widget.cpf)));
                    },
                    child: const Text("Cadastrar"),
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
