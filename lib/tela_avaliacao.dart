import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config/app_config.dart';

class TelaAvaliacao extends StatefulWidget {
  final int? servicoId;
  final String urlApi;

  const TelaAvaliacao({
    super.key,
    this.servicoId,
    this.urlApi = '${AppConfig.baseUrl}/api/avaliacoes',
  });

  @override
  State<TelaAvaliacao> createState() => _TelaAvaliacaoState();
}

class _TelaAvaliacaoState extends State<TelaAvaliacao> {
  List<dynamic> itensParaAvaliar = [];
  bool carregando = true;
  String? erro;

  @override
  void initState() {
    super.initState();
    carregarItensPendentes();
  }

  // Busca na API os atendimentos finalizados pendentes de avaliação
  Future<void> carregarItensPendentes() async {
    setState(() {
      carregando = true;
      erro = null;
    });

    try {
      final resposta = await http
          .get(Uri.parse('${widget.urlApi}/pendentes'))
          .timeout(AppConfig.timeout);

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(utf8.decode(resposta.bodyBytes));
        setState(() {
          itensParaAvaliar = dados is List ? dados : (dados['itens'] ?? []);
        });
      } else if (resposta.statusCode == 404) {
        setState(() {
          itensParaAvaliar = [];
        });
      } else {
        setState(() {
          erro = 'Erro ao carregar pendências (${resposta.statusCode}).';
        });
      }
    } catch (e) {
      setState(() {
        itensParaAvaliar = [];
      });
    } finally {
      if (mounted) {
        setState(() {
          carregando = false;
        });
      }
    }
  }

  // Envia a nota do serviço finalizado (1 = Ruim, 2 = Bom, 3 = Excelente conforme RNF03)
  Future<void> _enviarAvaliacao(int servicoId, int nota) async {
    try {
      final response = await http
          .post(
            Uri.parse(widget.urlApi),
            headers: {'Content-Type': 'application/json; charset=utf-8'},
            body: jsonEncode({
              'servico_id': servicoId,
              'nota': nota,
            }),
          )
          .timeout(AppConfig.timeout);

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Obrigado pela sua avaliação!')),
        );
        carregarItensPendentes();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao enviar (${response.statusCode}). Tente novamente.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro de conexão: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 251, 248, 255),
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (carregando) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.indigo),
              );
            }

            if (erro != null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(erro!, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: carregarItensPendentes,
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              );
            }

            if (itensParaAvaliar.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.rate_review_outlined, size: 56, color: Colors.grey),
                      SizedBox(height: 12),
                      Text(
                        'Nenhum atendimento pendente para avaliar.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: carregarItensPendentes,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: itensParaAvaliar.length,
                itemBuilder: (context, index) {
                  final item = itensParaAvaliar[index];
                  final int servicoId = item['id'] ?? item['servico_id'] ?? widget.servicoId ?? 1;
                  final String nomePet = item['nome_pet'] ?? item['nomePet'] ?? item['pet'] ?? 'Pet';
                  final String servico = item['descricao'] ?? item['servico'] ?? 'Atendimento';

                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.only(bottom: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.pets, color: Colors.indigo, size: 28),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      nomePet,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    Text('Serviço: $servico', style: TextStyle(color: Colors.grey.shade700)),
                                    const Text('Status: Finalizado', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          const Text(
                            'Como você avalia nosso atendimento?',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.red.shade50,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () => _enviarAvaliacao(servicoId, 1),
                                child: const Text('Ruim (1)', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.orange.shade50,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () => _enviarAvaliacao(servicoId, 2),
                                child: Text('Bom (2)', style: TextStyle(color: Colors.orange.shade900, fontWeight: FontWeight.bold)),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () => _enviarAvaliacao(servicoId, 3),
                                child: const Text('Excelente (3)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ],
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
    );
  }
}
