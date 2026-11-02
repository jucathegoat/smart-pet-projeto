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
    setState(() {
      carregando = true;
      erro = null;
    });

    try {
      final resposta = await http.get(
        Uri.parse('${baseUrl}/agendamentos/${widget.cpf}'),
      );

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);

        if (dados['sucesso'] == true) {
          setState(() {
            agendamentos = dados['agendamentos'] ?? [];
          });
        } else {
          setState(() {
            erro = 'Não foi possível carregar seus agendamentos.';
          });
        }
      } else {
        setState(() {
          erro = 'Erro ao consultar os agendamentos (${resposta.statusCode}).';
        });
      }
    } catch (e) {
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

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'em andamento':
        return Colors.orange;
      case 'concluído':
        return Colors.green;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _statusBackground(String status) {
    switch (status.toLowerCase()) {
      case 'em andamento':
        return Colors.orange.shade100;
      case 'concluído':
        return Colors.green.shade100;
      case 'cancelado':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (carregando) {
              return const Center(child: CircularProgressIndicator());
            }

            if (erro != null) {
              return Center(
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
              );
            }

            if (agendamentos.isEmpty) {
              return const Center(
                child: Text(
                  'Não há nenhum agendamento',
                  textAlign: TextAlign.center,
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: carregarAgendamentos,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: agendamentos.length,
                itemBuilder: (context, index) {
                  final agendamento = agendamentos[index];

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
                                    agendamento['nome_pet'] ?? 'Sem nome',
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
                                  color: _statusBackground(
                                    agendamento['status'] ?? '',
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  agendamento['status'] ?? 'Pendente',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: _statusColor(
                                      agendamento['status'] ?? '',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "🛁 Especialidade: ${agendamento['nome_servico'] ?? 'Não informada'}",
                          ),
                          Text(
                            "📅 Data: ${agendamento['data'] ?? 'Não informada'}",
                          ),
                          Text(
                            "⏰ Hora: ${agendamento['hora'] ?? 'Não informada'}",
                          ),
                          const SizedBox(height: 12),

                          // Botão de cancelar só aparece se status == "Em andamento"
                          if ((agendamento['status'] ?? '').toLowerCase() ==
                              'em andamento')
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(255, 26, 58, 27),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  "Cancelar",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  // lógica para cancelar o agendamento
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TelaNovoAgendamento(cpf: widget.cpf),
            ),
          );
        },
        shape: CircleBorder(side: BorderSide(color: Colors.white, width: 2.0)),
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color.fromARGB(255, 26, 58, 27),
      ),
    );
  }
}
