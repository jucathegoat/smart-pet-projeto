import 'package:flutter/material.dart';
import 'package:flutter_application_1/tela_novo_agendamento.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class TelaAgendamento extends StatefulWidget {
  const TelaAgendamento({super.key, required this.cpf});

  final String cpf;

  @override
  TelaAgendamentoState createState() => TelaAgendamentoState();
}

class TelaAgendamentoState extends State<TelaAgendamento> {
  List<dynamic> agendamentos = [];
  bool carregando = true;
  String? erro;

  final String baseUrl = 'http://localhost:8080';

  @override
  void initState() {
    super.initState();
    carregarAgendamentos();
  }

  Future<void> carregarAgendamentos() async {
    if (!mounted) return;

    setState(() {
      carregando = true;
      erro = null;
    });

    try {
      final cpfLimpo = widget.cpf.replaceAll(RegExp(r'[^0-9A-Za-z]'), '');
      final resposta = await http.get(
        Uri.parse('$baseUrl/api/fila/cliente/$cpfLimpo'),
      );

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);

        if (!mounted) return;

        setState(() {
          agendamentos = dados as List<dynamic>;
        });
      } else {
        if (!mounted) return;

        setState(() {
          erro = 'Erro ao consultar os agendamentos (${resposta.statusCode}).';
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        erro = 'Não foi possível conectar à API.';
      });
    } finally {
      if (mounted) {
        setState(() {
          carregando = false;
        });
      }
    }
  }

  Future<void> cancelarAgendamentos(int idagenda) async {
  try {
    final url = Uri.parse(
      '$baseUrl/api/agendamentos/$idagenda/cancelar',
    );

    final resposta = await http.put(url);

    if (resposta.statusCode == 200) {
      await carregarAgendamentos();
    } else {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível cancelar o agendamento.',
          ),
        ),
      );
    }
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Erro ao conectar ao servidor.',
        ),
      ),
    );
  }
}

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'agendado':
        return Colors.orange;
      case 'concluído':
        return Colors.green;
      case 'cancelado':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Color _statusBackground(String status) {
    switch (status.toLowerCase()) {
      case 'agendado':
        return Colors.orange.shade100;
      case 'concluído':
        return Colors.green.shade100;
      case 'cancelado':
        return Colors.grey.shade200;
      default:
        return Colors.grey.shade200;
    }
  }

  Future<void> abrirNovoAgendamento() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaNovoAgendamento(cpf: widget.cpf),
      ),
    );

    if (!mounted) return;

    if (resultado == true) {
      await carregarAgendamentos();
    }
  }

  Widget _construirConteudo() {
    if (carregando) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(
            height: 400,
            child: Center(child: CircularProgressIndicator()),
          ),
        ],
      );
    }

    if (erro != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: 400,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(erro!),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: carregarAgendamentos,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    if (agendamentos.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(
            height: 700,
            child: Center(
              child: Text(
                'Não há nenhum agendamento',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: agendamentos.length,
      itemBuilder: (context, index) {
        final agendamento = agendamentos[index];

        final status = agendamento['status'] ?? '';
        String textoOuPadrao(dynamic valor, [String padrao = 'Não informada']) {
          if (valor == null) return padrao;
          final texto = valor.toString().trim();
          if (texto.isEmpty || texto.toLowerCase() == 'null' || texto.toLowerCase() == 'undefined') {
            return padrao;
          }
          return texto;
        }

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: const Color.fromARGB(255, 249, 243, 243),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cabeçalho com nome e status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.pets, color: Colors.indigo),
                        const SizedBox(width: 8),
                        Text(
                          textoOuPadrao(agendamento['nomePet'], 'Sem nome'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),

                    // Badge de status
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _statusBackground(status),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status.isEmpty ? 'Pendente' : status,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _statusColor(status),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  "🛁 Especialidade: ${textoOuPadrao(agendamento['servico'])}",
                ),
                Text("📂 Categoria: ${textoOuPadrao(agendamento['categoria'])}"),
                Text(
                  "📅 Data: ${textoOuPadrao(agendamento['data_agendamento'])}",
                ),

                Text(
                  "⏰ Hora: ${textoOuPadrao(agendamento['hora_agendamento'])}",
                ),

                const SizedBox(height: 12),

                // Botão de cancelar
               if (status.toLowerCase() == 'agendado')
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 26, 58, 27),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: const Icon(Icons.cancel, color: Colors.white),
                      label: const Text(
                        "Cancelar",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirmação"),
                              content: const Text(
                                "Tem certeza que deseja cancelar este agendamento?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Não"),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      26,
                                      58,
                                      27,
                                    ),
                                  ),
                                  child: const Text(
                                    "Sim",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () async {
                                    Navigator.of(context).pop();

                                    final idagenda = agendamento['id'];

                                    await cancelarAgendamentos(idagenda);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: carregarAgendamentos,
          child: _construirConteudo(),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: abrirNovoAgendamento,
        shape: const CircleBorder(
          side: BorderSide(color: Colors.white, width: 2.0),
        ),
        backgroundColor: const Color.fromARGB(255, 26, 58, 27),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
