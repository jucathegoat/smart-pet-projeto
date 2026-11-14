
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  final String baseUrl = 'http://localhost:8080';

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

    try {
      final resposta = await http.get(
        Uri.parse('$baseUrl/tutor/${widget.cpf}/pets'),
      );

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);

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

  // Abrir tela de cadastro
  Future<void> abrirCadastro() async {
    final cadastrado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => TelaCadastroPet(cpf: widget.cpf),
      ),
    );

    if (!mounted) return;

    if (cadastrado == true) {
      await carregarPets();
    }
  }

  // Abrir tela de edição
  Future<void> abrirEdicao(dynamic pet) async {
    final id = pet['codigoPet'] as int;

    final resultado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => TelaEdicaoPet(
          codigoPet: id,
          nDocumento: pet['n_documento'] ?? '',
          peso: pet['peso'] ?? 0,
          idade: pet['idade'] ?? 0,
        ),
      ),
    );

    if (!mounted) return;

    if (resultado == true) {
      await carregarPets();
    }
  }

  // Excluir pet
  Future<void> deletarPet(int codigoPet) async {
    try {
      final url = Uri.parse('$baseUrl/deletar/pet/$codigoPet');

      final resposta = await http.delete(url);

      if (!mounted) return;

      if (resposta.statusCode == 204 || resposta.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pet excluído com sucesso!'),
          ),
        );

        await carregarPets();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao excluir pet.'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível conectar à API.'),
        ),
      );
    }
  }

  // Confirmar exclusão
  void confirmarExclusao(int codigoPet) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Confirmar exclusão"),
          content: const Text(
            "Tem certeza que deseja deletar este pet?",
          ),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 26, 58, 27),
              ),
              child: const Text(
                "Deletar",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                await deletarPet(codigoPet);
              },
            ),
          ],
        );
      },
    );
  }

  // Construção do conteúdo
  Widget construirConteudo() {
    if (carregando) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(
            height: 400,
            child: Center(
              child: CircularProgressIndicator(),
            ),
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
                    onPressed: carregarPets,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    if (pets.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(
            height: 700,
            child: Center(
              child: Text(
                'Não há nenhum pet cadastrado',
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
      itemCount: pets.length,
      itemBuilder: (context, index) {
        final pet = pets[index];

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
                // Cabeçalho com nome e botões
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pet['nome'] ?? 'Sem nome',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            pet['n_documento'] ?? 'Sem nº Documento',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Botão editar
                        IconButton(
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: Colors.blueAccent,
                          ),
                          onPressed: () => abrirEdicao(pet),
                        ),

                        // Botão excluir
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            final id = pet['codigoPet'] as int;

                            confirmarExclusao(id);
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Informações do pet
                Text(
                  '🐾 Espécie: ${pet['especie'] ?? 'Não informada'}',
                ),

                Text(
                  '🦴 Raça: ${pet['raca'] ?? 'Não informada'}',
                ),

                Text(
                  '📏 Porte: ${pet['porte'] ?? 'Não informada'}',
                ),

                Text(
                  '⚖️ Peso: ${pet['peso'] ?? 'Não informada'}',
                ),

                Text(
                  '🎂 Idade: ${pet['idade'] ?? 'Não informada'}',
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
          onRefresh: carregarPets,
          child: construirConteudo(),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: abrirCadastro,
        shape: const CircleBorder(
          side: BorderSide(
            color: Color.fromARGB(255, 248, 248, 248),
            width: 2,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 26, 58, 27),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
