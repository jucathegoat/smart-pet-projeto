import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TelaLoja extends StatefulWidget {
  const TelaLoja({super.key});

  @override
  State<TelaLoja> createState() => _TelaLojaState();
}

class _TelaLojaState extends State<TelaLoja> {
  List<dynamic> _produtos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _buscarProdutos();
  }

  Future<void> _buscarProdutos() async {
    setState(() => _carregando = true);
    try {
      final response = await http.get(Uri.parse('http://localhost:8086/api/produtos'));
      if (response.statusCode == 200) {
        final List<dynamic> dados = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          _produtos = dados;
          _carregando = false;
        });
      } else {
        setState(() => _carregando = false);
      }
    } catch (e) {
      setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F5),
      appBar: AppBar(
        title: const Text('Produtos & Pet Shop', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _buscarProdutos,
            tooltip: 'Recarregar Produtos',
          )
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1B5E20)))
          : _produtos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 12),
                      const Text('Não há Produtos Disponíveis', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _buscarProdutos,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.82,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _produtos.length,
                    itemBuilder: (context, index) {
                      final prod = _produtos[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        clipBehavior: Clip.antiAlias,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: Icon(Icons.pets, size: 40, color: Color(0xFF2E7D32)),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                prod['nome'] ?? 'Produto',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              Text(
                                prod['marca'] ?? 'SmartPet',
                                style: TextStyle(color: Colors.grey[600], fontSize: 11),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'R$ ${prod['preco']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xFF1B5E20),
                                    ),
                                  ),
                                  Text(
                                    '${prod['estoque']} un',
                                    style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}