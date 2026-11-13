import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';

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

  Future<bool> cadastrarPet() async {
    final idade = int.tryParse(idadeControler.text.trim());
    if (nomeControler.text.trim().isEmpty || racaControler.text.trim().isEmpty || idade == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha os dados do pet corretamente.')),
      );
      return false;
    }

    try {
      final resposta = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/cadastrar/pet'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'cpf': widget.cpf,
          'nome': nomeControler.text.trim(),
          'especie': racaControler.text.trim(),
          'idade': idade,
        }),
      );

      if (!mounted) return false;
      final sucesso = resposta.statusCode == 201 || resposta.statusCode == 200;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(sucesso ? 'Pet cadastrado com sucesso!' : 'Erro ao cadastrar pet')),
      );
      return sucesso;
    } catch (_) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível conectar à API.')),
      );
      return false;
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
                    onPressed: () async {
                      final cadastrou = await cadastrarPet();
                      if (cadastrou && context.mounted) Navigator.pop(context, true);
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
