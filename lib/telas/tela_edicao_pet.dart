import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';

class TelaEdicaoPet extends StatefulWidget {
  const TelaEdicaoPet({
    super.key,
    required this.codigoPet,
    required this.cpf,
    this.pesoInicial,
    this.nDocumentoInicial,
    this.idadeInicial,
  });

  final int codigoPet;
  final String cpf;
  final String? pesoInicial;
  final String? nDocumentoInicial;
  final int? idadeInicial;

  @override
  State<TelaEdicaoPet> createState() => _TelaEdicaoPetState();
}

class _TelaEdicaoPetState extends State<TelaEdicaoPet> {
  late final TextEditingController pesoController;
  late final TextEditingController nDocumentoController;
  late final TextEditingController idadeController;

  @override
  void initState() {
    super.initState();
    pesoController = TextEditingController(text: widget.pesoInicial ?? '');
    nDocumentoController = TextEditingController(text: widget.nDocumentoInicial ?? '');
    idadeController = TextEditingController(text: widget.idadeInicial?.toString() ?? '');
  }

  @override
  void dispose() {
    idadeController.dispose();
    pesoController.dispose();
    nDocumentoController.dispose();
    super.dispose();
  }

  Future<bool> atualizarPet() async {
    final idade = int.tryParse(idadeController.text.trim());
    if (idade == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe uma idade válida.')),
      );
      return false;
    }

    try {
      final resposta = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/api/pets/${widget.codigoPet}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'codigoPet': widget.codigoPet,
          'cpf': widget.cpf,
          'peso': pesoController.text.trim(),
          'n_documento': nDocumentoController.text.trim(),
          'idade': idade,
        }),
      );

      if (!mounted) return false;
      final sucesso = resposta.statusCode == 200;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            sucesso ? 'Pet atualizado com sucesso!' : 'Erro ao atualizar pet (${resposta.statusCode})',
          ),
        ),
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
          'Edição de Pet',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 249, 243, 243),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(34),
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextField(
                controller: nDocumentoController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nº Documento',
                  hintText: 'Digite o nº Documento do seu pet',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: pesoController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Peso',
                  hintText: 'Digite o peso do seu pet',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: idadeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Idade',
                  hintText: 'Digite a idade do seu pet',
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(Color.fromARGB(255, 26, 58, 27)),
                    ),
                    onPressed: () async {
                      final atualizado = await atualizarPet();
                      if (atualizado && context.mounted) Navigator.pop(context, true);
                    },
                    child: const Text('Atualizar'),
                  ),
                  const SizedBox(width: 10),
                  FilledButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(Color.fromARGB(255, 228, 230, 228)),
                    ),
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Voltar'),
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