import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config/app_config.dart';
import 'tela_avaliacao.dart';

class TelaLoja extends StatefulWidget {
  const TelaLoja({super.key, required this.cpf});

  final String cpf;

  @override
  State<TelaLoja> createState() => _TelaLojaState();
}

class _TelaLojaState extends State<TelaLoja> {
  late Future<List<Map<String, dynamic>>> _produtosFuture;
  int? _comprandoId;

  @override
  void initState() {
    super.initState();
    _produtosFuture = listarProdutos();
  }

  Future<List<Map<String, dynamic>>> listarProdutos() async {
    // Tenta primeiro /api/produtos (Spring Boot padrão) e fallback para /produto
    try {
      var response = await http
          .get(Uri.parse('${AppConfig.baseUrl}/api/produtos'))
          .timeout(AppConfig.timeout);

      if (response.statusCode != 200) {
        response = await http
            .get(Uri.parse('${AppConfig.baseUrl}/produto'))
            .timeout(AppConfig.timeout);
      }

      if (response.statusCode == 200) {
        final dynamic data = json.decode(utf8.decode(response.bodyBytes));
        List<dynamic> lista;
        if (data is List) {
          lista = data;
        } else if (data is Map && data['produtos'] != null) {
          lista = data['produtos'];
        } else {
          lista = [];
        }

        return lista.map((item) => {
          'id': item['id'] ?? item['id_produto'] ?? item['codigo'],
          'nome': item['nome'] ?? 'Produto',
          'marca': item['marca'] ?? '',
          'tipo': item['tipo'] ?? item['categoria'] ?? '',
          'estoque': item['estoque'] ?? 0,
          'preco': item['preco'] ?? 0.0,
          'codigo': item['codigo'] ?? '',
          'url': item['url'] ?? '',
        }).toList();
      } else {
        throw Exception('Erro ao carregar produtos (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Falha ao conectar com a loja: $e');
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _produtosFuture = listarProdutos();
    });
  }

  Future<void> _comprar(Map<String, dynamic> produto) async {
    final idProduto = int.tryParse(produto['id']?.toString() ?? '');
    if (idProduto == null || _comprandoId != null) return;

    setState(() => _comprandoId = idProduto);
    try {
      final resposta = await http
          .post(
            Uri.parse('${AppConfig.baseUrl}/api/vendas'),
            headers: {'Content-Type': 'application/json; charset=utf-8'},
            body: jsonEncode({
              'id_produto': idProduto,
              'quantidade': 1,
              'forma_pagamento': 'Pix',
              'cpf': widget.cpf.replaceAll(RegExp(r'[^0-9]'), ''),
            }),
          )
          .timeout(AppConfig.timeout);

      final dynamic dados = jsonDecode(utf8.decode(resposta.bodyBytes));
      if (!mounted) return;
      if (resposta.statusCode < 200 || resposta.statusCode >= 300 || dados['sucesso'] != true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(dados['mensagem']?.toString() ?? 'Não foi possível concluir a compra.')),
        );
        return;
      }

      await _refresh();
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Compra concluída'),
          content: Text('${produto['nome']} foi comprado. Quer avaliar sua compra agora?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Depois'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TelaAvaliacao(cpf: widget.cpf)),
                );
              },
              child: const Text('Avaliar compra'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao comprar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _comprandoId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 251, 248, 255),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _produtosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.indigo));
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text('Não foi possível carregar a loja.'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _refresh,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          final produtos = snapshot.data ?? [];

          if (produtos.isEmpty) {
            return const Center(
              child: Text('Nenhum produto cadastrado no momento.'),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.66,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                final prod = produtos[index];
                final preco = double.tryParse(prod['preco'].toString()) ?? 0.0;
                final String? url = prod['url'];

                return Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          ),
                          child: Center(
                            child: url != null && url.startsWith('http')
                                ? Image.network(
                                    url,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.pets, size: 48, color: Colors.indigo),
                                  )
                                : const Icon(Icons.shopping_bag_outlined, size: 48, color: Colors.indigo),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              prod['nome'] ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              prod['marca'] ?? '',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'R\$ ${preco.toStringAsFixed(2).replaceAll('.', ',')}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _comprandoId == null ? () => _comprar(prod) : null,
                                icon: _comprandoId == prod['id']
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : const Icon(Icons.shopping_cart_outlined),
                                label: Text(_comprandoId == prod['id'] ? 'Comprando…' : 'Comprar'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
