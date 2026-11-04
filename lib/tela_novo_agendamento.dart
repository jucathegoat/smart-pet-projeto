import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TelaNovoAgendamento extends StatefulWidget {
  final String? usuarioInicial;
  const TelaNovoAgendamento({super.key, this.usuarioInicial});

  @override
  State<TelaNovoAgendamento> createState() => _TelaNovoAgendamentoState();
}

class _TelaNovoAgendamentoState extends State<TelaNovoAgendamento> {
  final _clienteController = TextEditingController();
  final _petController = TextEditingController();
  final _telefoneController = TextEditingController();

  String servicoSelecionado = 'Banho e Tosa';
  bool enviando = false;

  @override
  void initState() {
    super.initState();
    if (widget.usuarioInicial != null) {
      _clienteController.text = widget.usuarioInicial!;
    }
  }

  @override
  void dispose() {
    _clienteController.dispose();
    _petController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  // IntegraÃ§Ã£o direta com o backend Java (Spring Boot / FilaController)
  Future<void> agendarNaFila() async {
    final cliente = _clienteController.text.trim();
    final pet = _petController.text.trim();

    if (cliente.isEmpty || pet.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, informe seu nome e o nome do pet!')),
      );
      return;
    }

    setState(() {
      enviando = true;
    });

    try {
      // URL do backend Spring Boot onde roda a fila em tempo real
      final url = Uri.parse(
        'http://localhost:8086/api/fila/adicionar?cliente=${Uri.encodeComponent(cliente)}&pet=${Uri.encodeComponent(pet)}&servico=${Uri.encodeComponent(servicoSelecionado)}',
      );

      final resposta = await http.post(url);

      if (!mounted) return;

      if (resposta.statusCode == 200 || resposta.statusCode == 201) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('ðŸŽ‰ Agendado com Sucesso!'),
            content: Text(
              'O pet "$pet" entrou na Fila de Atendimento do PetShop!\n\n'
              'ServiÃ§o: $servicoSelecionado\n\n'
              'O atendente jÃ¡ pode visualizar e chamar no painel administrativo.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context); // Volta para a tela anterior
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao entrar na fila: ${resposta.statusCode}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('NÃ£o foi possÃ­vel conectar ao servidor: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          enviando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
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
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Entrar na Fila de Atendimento",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _clienteController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Cliente / Tutor",
                  hintText: "Digite seu nome completo",
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: servicoSelecionado,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "ServiÃ§o Desejado",
                  prefixIcon: Icon(Icons.cleaning_services),
                ),
                items: const [
                  DropdownMenuItem(value: "Banho e Tosa", child: Text("Banho e Tosa")),
                  DropdownMenuItem(value: "Consulta VeterinÃ¡ria", child: Text("Consulta VeterinÃ¡ria")),
                  DropdownMenuItem(value: "VacinaÃ§Ã£o", child: Text("VacinaÃ§Ã£o")),
                  DropdownMenuItem(value: "Exame Geral", child: Text("Exame Geral")),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      servicoSelecionado = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _petController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Nome do Pet",
                  hintText: "Ex: Rex, Mel, Thor...",
                  prefixIcon: Icon(Icons.pets),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _telefoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Telefone de Contato",
                  hintText: "(xx) xxxxx-xxxx",
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(
                    const Color.fromARGB(255, 26, 58, 27),
                  ),
                  padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
                onPressed: enviando ? null : agendarNaFila,
                child: enviando
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        "Agendar e Entrar na Fila",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancelar", style: TextStyle(color: Colors.black87)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
