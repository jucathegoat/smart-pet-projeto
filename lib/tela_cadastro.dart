import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config/app_config.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _formKey = GlobalKey<FormState>();

  final nomeCtrl = TextEditingController();
  final cpfCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final telefoneCtrl = TextEditingController();
  final enderecoCtrl = TextEditingController();
  final usuarioCtrl = TextEditingController();
  final senhaCtrl = TextEditingController();

  bool salvando = false;

  final cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final telefoneFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  bool validarCPF(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    if (cpf.length != 11) return false;
    if (RegExp(r'^(\d)\1{10}$').hasMatch(cpf)) return false;

    int soma = 0;
    for (int i = 0; i < 9; i++) {
      soma += int.parse(cpf[i]) * (10 - i);
    }
    int resto = soma % 11;
    int digito1 = resto < 2 ? 0 : 11 - resto;
    if (int.parse(cpf[9]) != digito1) return false;

    soma = 0;
    for (int i = 0; i < 10; i++) {
      soma += int.parse(cpf[i]) * (11 - i);
    }
    resto = soma % 11;
    int digito2 = resto < 2 ? 0 : 11 - resto;
    return int.parse(cpf[10]) == digito2;
  }

  Future<void> cadastrarUsuario() async {
    if (!_formKey.currentState!.validate()) return;

    final cpfLimpo = cpfCtrl.text.replaceAll(RegExp(r'[^0-9]'), '');

    setState(() {
      salvando = true;
    });

    try {
      // Pré-validação de CPF conforme RF04
      final validarUrl = Uri.parse('${AppConfig.baseUrl}/api/clientes/validar/$cpfLimpo');
      final validacaoResp = await http.get(validarUrl).timeout(AppConfig.timeout);
      if (validacaoResp.statusCode == 200) {
        final valData = jsonDecode(utf8.decode(validacaoResp.bodyBytes));
        if (valData['situacao'] == 'bloqueado' || valData['bloqueado'] == true) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red.shade800,
              content: Text('CPF Bloqueado: ${valData['motivo'] ?? 'Procure a administração.'}'),
            ),
          );
          return;
        } else if (valData['situacao'] == 'existe' || valData['existe'] == true) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Este CPF já está cadastrado no sistema.')),
          );
          return;
        }
      }

      final url = Uri.parse('${AppConfig.baseUrl}/usuario');
      final resposta = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json; charset=utf-8'},
            body: jsonEncode({
              'nome': nomeCtrl.text.trim(),
              'cpf': cpfLimpo,
              'email': emailCtrl.text.trim(),
              'telefone': telefoneCtrl.text.trim(),
              'endereco': enderecoCtrl.text.trim(),
              'usuario': usuarioCtrl.text.trim(),
              'senha': senhaCtrl.text,
              'status_conta': 'Ativo',
            }),
          )
          .timeout(AppConfig.timeout);

      if (!mounted) return;

      if (resposta.statusCode == 201 || resposta.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário cadastrado com sucesso! Faça login.')),
        );
        Navigator.pop(context);
      } else if (resposta.statusCode == 403) {
        final dados = jsonDecode(utf8.decode(resposta.bodyBytes));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red.shade800,
            content: Text(dados['mensagem'] ?? 'CPF bloqueado pela administração.'),
          ),
        );
      } else {
        final dados = jsonDecode(utf8.decode(resposta.bodyBytes));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(dados['mensagem'] ?? 'Erro ao cadastrar usuário.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível conectar ao servidor.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          salvando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Tutor', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 249, 243, 243),
      ),
      backgroundColor: const Color.fromARGB(255, 251, 248, 255),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nomeCtrl,
                decoration: const InputDecoration(labelText: 'Nome Completo *', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe seu nome' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: cpfCtrl,
                inputFormatters: [cpfFormatter],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'CPF *', border: OutlineInputBorder()),
                validator: (v) => validarCPF(v ?? '') ? null : 'CPF inválido',
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'E-mail *', border: OutlineInputBorder()),
                validator: (v) => (v == null || !v.contains('@')) ? 'E-mail inválido' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: telefoneCtrl,
                inputFormatters: [telefoneFormatter],
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Telefone', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: enderecoCtrl,
                decoration: const InputDecoration(labelText: 'Endereço', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: usuarioCtrl,
                decoration: const InputDecoration(labelText: 'Nome de Usuário *', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().length < 3) ? 'Mínimo 3 caracteres' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: senhaCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Senha *', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.length < 4) ? 'Mínimo 4 caracteres' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 26, 58, 27),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: salvando ? null : cadastrarUsuario,
                  child: salvando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Concluir Cadastro',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
