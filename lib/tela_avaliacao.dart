import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TelaAvaliacao extends StatefulWidget {
  final int? servicoId;
  final String urlApi;

  const TelaAvaliacao({
    super.key,
    this.servicoId,
    this.urlApi = 'http://localhost:8086/api/avaliacoes',
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

  // Busca na API os atendimentos finalizados pendentes de avaliaÃƒÂ§ÃƒÂ£o
  Future<void> carregarItensPendentes() async {
    setState(() {
      carregando = true;
      erro = null;
    });

    try {
      final resposta = await http.get(
        Uri.parse('${widget.urlApi}/pendentes'),
      );

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);
        setState(() {
          itensParaAvaliar = dados is List ? dados : (dados['itens'] ?? []);
        });
      } else if (resposta.statusCode == 404) {
        // Se a rota nÃƒÂ£o existir no backend, trata como lista vazia
        setState(() {
          itensParaAvaliar = [];
        });
      } else {
        setState(() {
          erro = 'Erro ao carregar (${resposta.statusCode}).';
        });
      }
    } catch (e) {
      // Se nÃƒÂ£o houver conexÃƒÂ£o, nÃƒÂ£o trava a tela com erro grave
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

  // Envia a nota do serviÃƒÂ§o finalizado
  Future<void> _enviarAvaliacao(int servicoId, int nota) async {
    try {
      final response = await http.post(
        Uri.parse(widget.urlApi),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'servico_id': servicoId,
          'nota': nota,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Obrigado pela sua avaliaÃƒÂ§ÃƒÂ£o!')),
        );
        carregarItensPendentes(); // Remove o item avaliado da lista
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao enviar (${response.statusCode}). Tente novamente.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro de conexÃƒÂ£o: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fundo em tom creme/suave idÃƒÂªntico ÃƒÂ  Tela de Pets
      backgroundColor: const Color.fromARGB(255, 255, 252, 243),
      appBar: AppBar(
        title: const Text(
          'Avaliar Atendimento',
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 249, 243, 243),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
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

            // MENSAGEM QUANDO NÃƒÆ’O HOUVER ATENDIMENTOS FINALIZADOS
            if (itensParaAvaliar.isEmpty) {
              return const Center(
                child: Text(
                  'NÃƒÂ£o contem item para avaliar',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            // LISTA DE CARDS ESTILIZADOS IGUAL A TELA DE PETS
            return RefreshIndicator(
              onRefresh: carregarItensPendentes,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: itensParaAvaliar.length,
                itemBuilder: (context, index) {
                  final item = itensParaAvaliar[index];
                  final int servicoId = item['id'] ?? item['servico_id'] ?? widget.servicoId ?? 1;
                  final String nomePet = item['nome_pet'] ?? item['pet'] ?? 'Garfield';
                  final String servico = item['descricao'] ?? item['servico'] ?? 'Banho e Tosa';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 245, 242, 248), // Mesma cor do card dos pets
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // ÃƒÂcone da pata ÃƒÂ  esquerda
                            const Icon(
                              Icons.pets,
                              color: Color.fromARGB(255, 70, 70, 70),
                              size: 28,
                            ),
                            const SizedBox(width: 16),
                            // InformaÃƒÂ§ÃƒÂµes do Chamado / Pet
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    nomePet,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'ServiÃƒÂ§o: $servico',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  Text(
                                    'Status: ConcluÃƒÂ­do',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(height: 1),
                        ),
                        const Text(
                          'Como foi o serviÃƒÂ§o?',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // BotÃƒÂµes de AvaliaÃƒÂ§ÃƒÂ£o integrados no prÃƒÂ³prio Card
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.red.shade50,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () => _enviarAvaliacao(servicoId, 1),
                              child: const Text('Ruim', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.orange.shade50,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () => _enviarAvaliacao(servicoId, 2),
                              child: Text('Bom', style: TextStyle(color: Colors.orange.shade900, fontWeight: FontWeight.bold)),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () => _enviarAvaliacao(servicoId, 3),
                              child: const Text('Excelente', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
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

