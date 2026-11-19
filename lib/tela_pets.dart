import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config/app_config.dart';
import 'tela_cadastro_pet.dart';
import 'tela_edicao_pet.dart';

class TelaPets extends StatefulWidget {
  const TelaPets({super.key, required this.cpf});

  final String cpf;

  @override
  State<TelaPets> createState() => _TelaPetsState();
}

class _TelaPetsState extends State<TelaPets> {
  List<dynamic> pets = [];
  bool carregando = true;
  String? erro;

  @override
  void initState() {
    super.initState();
    carregarPets();
  }

  Future<void> carregarPets() async {
    if (!mounted) return;

    setState(() {
      carregando = true;
      erro = null;
    });

    final cpfLimpo = widget.cpf.replaceAll(RegExp(r'[^0-9A-Za-z]'), '');

    try {
      final resposta = await http
          .get(Uri.parse('${AppConfig.baseUrl}/tutor/$cpfLimpo/pets'))
          .timeout(AppConfig.timeout);

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(utf8.decode(resposta.bodyBytes));
        if (dados['sucesso'] == true) {
          if (!mounted) return;
          setState(() {
            pets = dados['pets'] ?? [];
          });
        } else {
          if (!mounted) return;
          setState(() {
            erro = 'Não foi possível carregar seus pets.';
          });
        }
      } else {
        if (!mounted) return;
        setState(() {
          erro = 'Erro ao consultar os pets (${resposta.statusCode}).';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        erro = 'Não foi possível conectar ao servidor.';
      });
    } finally {
      if (mounted) {
        setState(() {
          carregando = false;
        });
      }
    }
  }

  Future<void> excluirPet(int id) async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Pet?'),
        content: const Text('Tem certeza que deseja remover este pet?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    try {
      final resposta = await http
          .delete(Uri.parse('${AppConfig.baseUrl}/api/pets/$id'))
          .timeout(AppConfig.timeout);

      if (resposta.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pet removido com sucesso.')),
        );
        carregarPets();
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao remover pet (${resposta.statusCode}).')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha na conexão ao excluir pet.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 251, 248, 255),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.indigo,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Novo Pet', style: TextStyle(color: Colors.white)),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TelaCadastroPet(cpf: widget.cpf),
            ),
          );
          carregarPets();
        },
      ),
      body: Builder(
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
                  const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(erro!, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: carregarPets,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          if (pets.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.pets, size: 64, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      'Nenhum pet cadastrado.',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Toque no botão abaixo para adicionar seu pet.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: carregarPets,
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
              itemCount: pets.length,
              itemBuilder: (context, index) {
                final pet = pets[index];
                final int id = pet['id'] ?? pet['codigo_pet'] ?? 0;
                final String nome = pet['nome'] ?? 'Pet';
                final String raca = pet['raca'] ?? 'Sem raça';
                final String especie = pet['especie'] ?? 'Canino';
                final int idade = pet['idade'] ?? 0;

                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo.shade50,
                      child: const Icon(Icons.pets, color: Colors.indigo),
                    ),
                    title: Text(
                      nome,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                      '$especie • $raca • $idade anos',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: Colors.indigo),
                          onPressed: () async {
                            final double pesoVal = double.tryParse(pet['peso']?.toString() ?? '0') ?? 0.0;
                            final String nDoc = pet['nDocumento']?.toString() ?? pet['n_documento']?.toString() ?? widget.cpf;
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TelaEdicaoPet(
                                  codigoPet: id,
                                  nDocumento: nDoc,
                                  peso: pesoVal,
                                  idade: idade,
                                ),
                              ),
                            );
                            carregarPets();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => excluirPet(id),
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
    );
  }
}
