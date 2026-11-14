import 'package:flutter/material.dart';

import '../config/api_config.dart';
import '../servicos/api_cliente.dart';
import 'tela_meus_atendimentos.dart';

class TelaNovoAgendamento extends StatefulWidget {
  final String? usuarioInicial;
  final String? cpfInicial;
  const TelaNovoAgendamento({super.key, this.usuarioInicial, this.cpfInicial});

  @override
  State<TelaNovoAgendamento> createState() => _TelaNovoAgendamentoState();
}

class _TelaNovoAgendamentoState extends State<TelaNovoAgendamento> {
  final _clienteController = TextEditingController();
  final _petController = TextEditingController();
  final _telefoneController = TextEditingController();

  String servicoSelecionado = 'Banho e Tosa';
  List<String> servicos = [
    'Banho e Tosa',
    'Consulta Veterinária',
    'Vacinação',
    'Exame Geral',
  ];
  bool enviando = false;

  @override
  void initState() {
    super.initState();
    if (widget.usuarioInicial != null) {
      _clienteController.text = widget.usuarioInicial!;
    }
    carregarServicos();
  }

  Future<void> carregarServicos() async {
    try {
      final dados = await ApiCliente.getJson(
        Uri.parse('${ApiConfig.baseUrl}/api/servicos'),
      );
      final lista = (dados['servicos'] as List<dynamic>? ?? [])
          .map(
            (item) => (item as Map<String, dynamic>)['nome']?.toString() ?? '',
          )
          .where((nome) => nome.isNotEmpty)
          .toList();
      if (lista.isNotEmpty && mounted) {
        setState(() {
          servicos = lista;
          if (!servicos.contains(servicoSelecionado)) {
            servicoSelecionado = servicos.first;
          }
        });
      }
    } on ApiException catch (e) {
      ApiCliente.logar(e, StackTrace.current);
      // Mantém as opções locais se o servidor ainda não estiver disponível.
    } catch (e, s) {
      ApiCliente.logar(e, s);
    }
  }

  @override
  void dispose() {
    _clienteController.dispose();
    _petController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  // Integração direta com o backend Java (Spring Boot / FilaController)
  Future<void> agendarNaFila() async {
    final cliente = _clienteController.text.trim();
    final pet = _petController.text.trim();

    if (cliente.isEmpty || pet.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, informe seu nome e o nome do pet!'),
        ),
      );
      return;
    }

    final cpf = (widget.cpfInicial ?? '').trim();
    if (cpf.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Sessão sem CPF: saia e entre novamente para agendar.',
          ),
        ),
      );
      return;
    }

    setState(() {
      enviando = true;
    });

    try {
      final dados = await ApiCliente.postJson(
        Uri.parse('${ApiConfig.baseUrl}/api/fila/adicionar'),
        corpo: {
          'cpf': cpf,
          'cliente': cliente,
          'pet': pet,
          'servico': servicoSelecionado,
        },
      );

      if (!mounted) return;

      final posicao = dados["posicao"] ?? "-";
      final esperaMinutos = dados["esperaMinutos"] ?? 0;
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Agendado com sucesso!'),
            content: Text(
              'O pet "$pet" entrou na Fila de Atendimento do PetShop!\n\n'
              'Serviço: $servicoSelecionado\n\n'
              'Posição na fila: $posicao\n'
              'Espera atual: $esperaMinutos min\n\n'
              'O atendente já pode visualizar e chamar no painel administrativo.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context); // Volta para a tela anterior
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
    } on ApiException catch (e) {
      ApiCliente.logar(e, StackTrace.current);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.mensagem)),
      );
    } catch (e, s) {
      ApiCliente.logar(e, s);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível conectar ao servidor: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          enviando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Novo Agendamento",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 249, 243, 243),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Entrar na Fila de Atendimento",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              if (widget.cpfInicial != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            TelaMeusAtendimentos(cpf: widget.cpfInicial!),
                      ),
                    ),
                    icon: const Icon(Icons.history),
                    label: const Text('Meus atendimentos'),
                  ),
                ),
              TextField(
                controller: _clienteController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Cliente / Tutor",
                  hintText: "Digite seu nome completo",
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: servicoSelecionado,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Serviço Desejado",
                  prefixIcon: Icon(Icons.cleaning_services),
                ),
                items: servicos
                    .map(
                      (nome) =>
                          DropdownMenuItem(value: nome, child: Text(nome)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      servicoSelecionado = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _petController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Nome do Pet",
                  hintText: "Ex: Rex, Mel, Thor...",
                  prefixIcon: Icon(Icons.pets),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _telefoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Telefone de Contato",
                  hintText: "(xx) xxxxx-xxxx",
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(
                    const Color.fromARGB(255, 26, 58, 27),
                  ),
                  padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
                onPressed: enviando ? null : agendarNaFila,
                child: enviando
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Agendar e Entrar na Fila",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Cancelar",
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
