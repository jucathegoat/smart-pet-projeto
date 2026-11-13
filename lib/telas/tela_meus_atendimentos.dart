import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';

class TelaMeusAtendimentos extends StatefulWidget {
  const TelaMeusAtendimentos({super.key, required this.cpf});

  final String cpf;

  @override
  State<TelaMeusAtendimentos> createState() => _TelaMeusAtendimentosState();
}

class _TelaMeusAtendimentosState extends State<TelaMeusAtendimentos> {
  List<dynamic> atendimentos = [];
  bool carregando = true;
  String? erro;

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    setState(() {
      carregando = true;
      erro = null;
    });
    try {
      final uri = Uri.parse(
        '${ApiConfig.baseUrl}/api/fila/cliente/${Uri.encodeComponent(widget.cpf)}',
      );
      final resposta = await http.get(uri);
      if (resposta.statusCode != 200)
        throw Exception('HTTP ${resposta.statusCode}');
      final dados =
          jsonDecode(utf8.decode(resposta.bodyBytes)) as List<dynamic>;
      if (mounted) setState(() => atendimentos = dados);
    } catch (_) {
      if (mounted)
        setState(() => erro = 'Não foi possível carregar seus atendimentos.');
    } finally {
      if (mounted) setState(() => carregando = false);
    }
  }

  Future<void> cancelar(dynamic item) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar atendimento?'),
        content: const Text('Esta ação remove o atendimento da sua fila.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Voltar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cancelar atendimento'),
          ),
        ],
      ),
    );
    if (confirmar != true) return;
    try {
      final id = item['id'];
      final uri = Uri.parse('${ApiConfig.baseUrl}/api/fila/$id/cancelar')
          .replace(queryParameters: {'cpf': widget.cpf});
      final resposta = await http.post(uri);
      if (!mounted) return;
      if (resposta.statusCode == 200) {
        await carregar();
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Atendimento cancelado.')),
          );
      } else {
        final dados = jsonDecode(utf8.decode(resposta.bodyBytes));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(dados['mensagem'] ?? 'Não foi possível cancelar.'),
          ),
        );
      }
    } catch (_) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível conectar à API.')),
        );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Meus atendimentos')),
    body: carregando
        ? const Center(child: CircularProgressIndicator())
        : erro != null
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(erro!),
                TextButton(
                  onPressed: carregar,
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          )
        : atendimentos.isEmpty
        ? const Center(child: Text('Você ainda não possui atendimentos.'))
        : RefreshIndicator(
            onRefresh: carregar,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: atendimentos.length,
              itemBuilder: (context, index) {
                final item = atendimentos[index] as Map<String, dynamic>;
                final status = item['status'] ?? 'Em espera';
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.pets),
                    title: Text(
                      '${item['nomePet'] ?? 'Pet'} · ${item['servico'] ?? 'Atendimento'}',
                    ),
                    subtitle: Text(
                      'Status: $status\nPosição: ${item['posicao'] ?? '-'} · Espera: ${item['esperaMinutos'] ?? item['minutosEspera'] ?? 0} min',
                    ),
                    isThreeLine: true,
                    trailing: status == 'Em espera'
                        ? IconButton(
                            tooltip: 'Cancelar atendimento',
                            icon: const Icon(Icons.cancel_outlined),
                            onPressed: () => cancelar(item),
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
  );
}
