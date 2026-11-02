import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TelaLoja extends StatefulWidget {
  const TelaLoja({super.key});

  @override
  State<TelaLoja> createState() => _TelaLojaState();
}

class _TelaLojaState extends State<TelaLoja> {
  late Future<List<Map<String, dynamic>>> _produtosFuture;

  @override
  void initState() {
    super.initState();
    _produtosFuture = listarProdutos();
  }

  Future<List<Map<String, dynamic>>> listarProdutos() async {
    final response = await http.get(Uri.parse("http://localhost:8080/produto"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["sucesso"] == true) {
        final List<dynamic> lista = data["produtos"];
        return lista.map((item) => {
          "id": item["id_produto"],
          "nome": item["nome"],
          "marca": item["marca"],
          "tipo": item["tipo"],
          "estoque": item["estoque"],
          "preco": item["preco"],
          "codigo": item["codigo"],
          "url": item["url"],
        }).toList();
      } else {
        throw Exception("API retornou sucesso = false");
      }
    } else {
      throw Exception("Erro ao carregar produtos");
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _produtosFuture = listarProdutos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _produtosFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Erro: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Não há Produtos Disponíveis"));
            }

            final produtos = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                final produto = produtos[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                          child: Image.network(
                            produto['url'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              produto['nome'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Marca: ${produto['marca']}",
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "R\$ ${produto['preco'].toString()}",
                              style: const TextStyle(
                                color: Colors.indigo,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: const Icon(Icons.add_shopping_cart,
                                  color: Colors.white),
                              label: const Text("Adicionar",
                                  style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "${produto['nome']} adicionado ao carrinho!"),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
