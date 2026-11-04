import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Notificacoes extends StatefulWidget {
  const Notificacoes({super.key});

  @override
  State<Notificacoes> createState() => _NotificacoesState();
}

class _NotificacoesState extends State<Notificacoes> {
  List<dynamic> _notificacoes = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _buscarNotificacoes();
  }

  Future<void> _buscarNotificacoes() async {
    setState(() => _carregando = true);
    try {
      final response = await http.get(Uri.parse('http://localhost:8086/api/notificacoes'));
      if (response.statusCode == 200) {
        final List<dynamic> dados = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          _notificacoes = dados;
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
        title: const Text('Notificações', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _buscarNotificacoes,
          )
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1B5E20)))
          : _notificacoes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_none, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 12),
                      const Text('Não há notificações', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _buscarNotificacoes,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _notificacoes.length,
                    itemBuilder: (context, index) {
                      final notif = _notificacoes[index];
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.only(bottom: 10),
                        elevation: 1.5,
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFFE8F5E9),
                            child: Icon(Icons.notifications_active, color: Color(0xFF2E7D32)),
                          ),
                          title: Text(
                            notif['titulo'] ?? 'Aviso SmartPet',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(notif['mensagem'] ?? ''),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}