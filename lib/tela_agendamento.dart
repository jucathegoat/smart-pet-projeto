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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendamentos'),
        backgroundColor: Color.fromARGB(255, 249, 243, 243),
        foregroundColor: Colors.black,
      ),
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
                    child: ListTile(
                      leading: const Icon(Icons.pets),
                      title: Text(agendamento['nome_pet'] ?? 'Sem nome'),
                      subtitle: Text(
                        'especialidade: ${agendamento['especialidade'] ?? 'Não informada'}\n'
                        'data: ${agendamento['data'] ?? 'Não informada'}\n'
                        'hora: ${agendamento['hora'] ?? 'Não informada'}',
                      ),
                      trailing: Wrap(
                        direction: Axis.vertical,
                        spacing: 4,
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
        shape: CircleBorder(
          side: BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
