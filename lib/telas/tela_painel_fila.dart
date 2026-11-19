import 'dart:async';
import 'package:flutter/material.dart';
import '../modelos/item_fila.dart';
import '../servicos/fila_servico.dart';

class TelaPainelFila extends StatefulWidget {
  const TelaPainelFila({super.key});

  @override
  State<TelaPainelFila> createState() => _TelaPainelFilaState();
}

class _TelaPainelFilaState extends State<TelaPainelFila> {
  final FilaServico _filaServico = FilaServico();
  List<ItemFila> _fila = [];
  bool _carregando = true;
  bool _semConexao = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _carregar();
    // Atualização em tempo real da TV da recepção a cada 10 segundos
    _timer = Timer.periodic(const Duration(seconds: 10), (t) {
      _carregar(silencioso: true);
    });
  }

  Future<void> _carregar({bool silencioso = false}) async {
    if (!silencioso && mounted) {
      setState(() {
        _carregando = true;
      });
    }

    try {
      final lista = await _filaServico.obterFilaGeral();
      if (!mounted) return;
      setState(() {
        _fila = lista;
        _carregando = false;
        _semConexao = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _carregando = false;
        _semConexao = true;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(
        backgroundColor: Color(0xFF1E1B2E),
        body: Center(
          child: CircularProgressIndicator(color: Colors.amber),
        ),
      );
    }

    ItemFila? atual;
    for (final item in _fila) {
      if (item.status == StatusFila.emAtendimento) {
        atual = item;
        break;
      }
    }

    final emEspera = _fila.where((item) => item.status == StatusFila.emEspera || item.status == StatusFila.aguardando).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF1A1829),
      body: SafeArea(
        child: RefreshIndicator(
          color: Colors.amber,
          onRefresh: () => _carregar(),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (_semConexao)
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade900,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Sem conexão com o servidor. Tentando reconectar...',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),

              // HEADER ESTILO PAINEL TV
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'PAINEL DA RECEPÇÃO',
                    style: TextStyle(
                      color: Colors.white70,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text('AO VIVO', style: TextStyle(color: Colors.greenAccent, fontSize: 12)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // CARTÃO DA SENHA ATUAL (DESTAQUE GRANDE)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2E264E), Color(0xFF1F1A3A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber.shade700, width: 2),
                ),
                child: Column(
                  children: [
                    const Text(
                      'SENHA ATUAL EM ATENDIMENTO',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      atual == null ? '—' : atual.senha,
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (atual != null) ...[
                      Text(
                        '${atual.nomePet} (${atual.nomeCliente})',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        atual.servico,
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ] else
                      const Text(
                        'Nenhum pet sendo atendido no momento',
                        style: TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // LISTA DE PRÓXIMAS SENHAS
              const Text(
                'PRÓXIMAS SENHAS',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),

              if (emEspera.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF26223D),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'Fila de espera vazia.',
                      style: TextStyle(color: Colors.white54, fontSize: 15),
                    ),
                  ),
                )
              else
                ...emEspera.take(6).map((item) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF26223D),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.amber.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item.senha,
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.nomePet,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  item.servico,
                                  style: const TextStyle(color: Colors.white60, fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          item.horarioChegada.isNotEmpty ? item.horarioChegada : '~${item.esperaMinutos} min',
                          style: const TextStyle(color: Colors.white54, fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}
