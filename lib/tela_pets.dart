
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'tela_cadastro_pet.dart';

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

  // Ajuste a porta para a porta em que sua API está rodando.
  final String baseUrl = 'http://localhost:8080';

  @override
  void initState() {
    super.initState();
    carregarPets();
  }

  Future<void> carregarPets() async {
    setState(() {
      carregando = true;
      erro = null;
    });

    try {
      final resposta = await http.get(
        Uri.parse('${baseUrl}/tutor/${widget.cpf}/pets'),
      );

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);

        if (dados['sucesso'] == true) {
          setState(() {
            pets = dados['pets'] ?? [];
          });
        } else {
          setState(() {
            erro = 'Não foi possível carregar seus pets.';
          });
        }
      } else {
        setState(() {
          erro = 'Erro ao consultar os pets (${resposta.statusCode}).';
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

  Future<void> abrirCadastro() async {
    final cadastrado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => TelaCadastroPet(cpf: widget.cpf),
      ),
    );

    if (cadastrado == true) {
      await carregarPets();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus pets'),
        backgroundColor: const Color.fromARGB(255, 249, 243, 243),
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (carregando) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (erro != null) {
              return Center(
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
              );
            }

            if (pets.isEmpty) {
              return const Center(
                child: Text(
                  'Não há nenhum pet cadastrado',
                  textAlign: TextAlign.center,
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: carregarPets,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: pets.length,
                itemBuilder: (context, index) {
                  final pet = pets[index];

                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.pets),
                      title: Text(pet['nome'] ?? 'Sem nome'),
                      subtitle: Text(
                        'Espécie: ${pet['especie'] ?? 'Não informada'}\n'
                        'Idade: ${pet['idade'] ?? 'Não informada'}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: null,
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
        onPressed: abrirCadastro,
        shape: const CircleBorder(
          side: BorderSide(color: Colors.black, width: 2),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
