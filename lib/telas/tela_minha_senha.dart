import 'package:flutter/material.dart';
import '../modelos/item_fila.dart';
import '../servicos/fila_servico.dart';

class TelaMinhaSenha extends StatefulWidget {
  final String cpf;
  final String usuario;

  const TelaMinhaSenha({
    super.key,
    required this.cpf,
    required this.usuario,
  });

  @override
  State<TelaMinhaSenha> createState() => _TelaMinhaSenhaState();
}

class _TelaMinhaSenhaState extends State<TelaMinhaSenha> {
  final FilaServico _filaServico = FilaServico();
  List<ItemFila> _meusAtendimentos = [];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    if (!mounted) return;
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final lista = await _filaServico.obterFilaDoCliente(widget.cpf);
      if (!mounted) return;
      setState(() {
        _meusAtendimentos = lista;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _carregando = false;
        _erro = 'Não foi possível carregar suas senhas.';
      });
    }
  }

  Future<void> _confirmarCancelamento(ItemFila item) async {
    final TextEditingController motivoCtrl = TextEditingController(
      text: 'Cancelado pelo cliente no aplicativo',
    );

    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancelar Senha?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Deseja cancelar o atendimento da senha ${item.senha} (${item.nomePet})?'),
            const SizedBox(height: 12),
            TextField(
              controller: motivoCtrl,
              decoration: const InputDecoration(
                labelText: 'Motivo do cancelamento',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Voltar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirmar Cancelamento', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      final sucesso = await _filaServico.cancelarAtendimento(item.id, motivo: motivoCtrl.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(sucesso ? 'Atendimento cancelado.' : 'Falha ao cancelar atendimento.'),
          ),
        );
        _carregar();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.indigo),
      );
    }

    final ativos = _meusAtendimentos.where((a) => a.estaAtivo).toList();
    final historico = _meusAtendimentos.where((a) => !a.estaAtivo).toList();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 251, 248, 255),
      body: RefreshIndicator(
        onRefresh: _carregar,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (_erro != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(_erro!, style: const TextStyle(color: Colors.red)),
              ),
            if (ativos.isEmpty)
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 36, horizontal: 16),
                  child: Column(
                    children: [
                      Icon(Icons.confirmation_number_outlined, size: 64, color: Colors.grey),
                      SizedBox(height: 12),
                      Text(
                        'Você não possui nenhuma senha ativa na fila.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Agende um serviço ou retire uma senha presencial na recepção para acompanhar o status por aqui.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...ativos.map((item) => _construirCardSenhaAtiva(item)),
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              color: Colors.indigo.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const ListTile(
                leading: Icon(Icons.info_outline, color: Colors.indigo),
                title: Text(
                  'Como funciona a fila?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                subtitle: Text(
                  'Senhas com "A" são de atendimentos agendados e têm prioridade no horário. Senhas com "P" são presenciais por ordem de chegada.',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ),
            if (historico.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text(
                'Histórico Recente',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...historico.map((item) => _construirCardHistorico(item)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _construirCardSenhaAtiva(ItemFila item) {
    final bool emAtendimento = item.estaEmAtendimento;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      color: emAtendimento ? const Color(0xFFE8F5E9) : const Color(0xFFE8EAF6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: emAtendimento ? Colors.green : Colors.indigo.shade200,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    emAtendimento ? 'EM ATENDIMENTO' : 'AGUARDANDO CHAMADA',
                    style: TextStyle(
                      color: emAtendimento ? Colors.green.shade900 : Colors.indigo.shade900,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                  backgroundColor: emAtendimento ? Colors.green.shade100 : Colors.indigo.shade100,
                ),
                Text(
                  'Pet: ${item.nomePet}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Sua Senha',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            Text(
              item.senha,
              style: TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.bold,
                color: emAtendimento ? Colors.green.shade800 : Colors.indigo.shade900,
              ),
            ),
            Text(
              item.servico,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const Divider(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('Posição na Fila', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(
                      emAtendimento ? 'Sua Vez!' : '${item.posicao}º',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: emAtendimento ? Colors.green : Colors.black87,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Tempo Estimado', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(
                      emAtendimento ? 'No balcão' : '~${item.esperaMinutos} min',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (!emAtendimento)
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
                icon: const Icon(Icons.cancel_outlined, size: 18),
                label: const Text('Cancelar Atendimento'),
                onPressed: () => _confirmarCancelamento(item),
              ),
          ],
        ),
      ),
    );
  }

  Widget _construirCardHistorico(ItemFila item) {
    final bool cancelado = item.status.toLowerCase().contains('cancel');
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: ListTile(
        leading: Icon(
          cancelado ? Icons.cancel : Icons.check_circle,
          color: cancelado ? Colors.red : Colors.green,
        ),
        title: Text('${item.servico} • ${item.nomePet}'),
        subtitle: Text(
          'Senha: ${item.senha} | Status: ${item.status}'
          '${item.motivoCancelamento.isNotEmpty ? ' (${item.motivoCancelamento})' : ''}',
        ),
      ),
    );
  }
}
