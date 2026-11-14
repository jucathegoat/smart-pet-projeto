import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/telas/tela_cadastro.dart';
import 'package:flutter/material.dart';

import '../config/api_config.dart';
import '../servicos/api_cliente.dart';

void main() {
  runApp(const TelaLogin());
}

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  TelaLoginState createState() => TelaLoginState();
}

class TelaLoginState extends State<TelaLogin> {
  final usuarioControler = TextEditingController();
  final senhaControler = TextEditingController();

  bool _entrando = false;

  Future<void> fazerLoign() async {
    if (_entrando) return;
    FocusScope.of(context).unfocus();

    setState(() => _entrando = true);
    try {
      final dados = await ApiCliente.postJson(
        Uri.parse('${ApiConfig.baseUrl}/login/usuario'),
        corpo: {
          'usuario': usuarioControler.text.trim(),
          'senha': senhaControler.text,
        },
      );

      if (!mounted) return;

      if (dados['sucesso'] == true) {
        final cpf = dados['cpf']?.toString() ?? '';
        final nome = dados['nome']?.toString() ?? usuarioControler.text.trim();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login realizado com sucesso!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TelaInicial(usuario: nome, cpf: cpf),
          ),
        );
      } else {
        _avisar(dados['mensagem']?.toString() ?? 'Usuário ou senha incorretos.');
      }
    } on ApiException catch (e) {
      ApiCliente.logar(e, StackTrace.current);
      if (!mounted) return;
      _avisar(
        e.statusCode == 401
            ? 'Usuário ou senha incorretos.'
            : '${e.mensagem}\nEndereço usado: ${ApiConfig.baseUrl}',
      );
    } catch (e, s) {
      ApiCliente.logar(e, s);
      if (!mounted) return;
      _avisar('Não foi possível entrar. Tente novamente.');
    } finally {
      if (mounted) setState(() => _entrando = false);
    }
  }

  void _avisar(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    usuarioControler.clear();
    senhaControler.clear();
  }

  @override
  void dispose() {
    usuarioControler.dispose();
    senhaControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 252, 243),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 170,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 70),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: usuarioControler,
                  obscureText: false,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Usuário",
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: senhaControler,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => fazerLoign(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Senha",
                  ),
                ),
              ),
              SizedBox(height: 20),
              FilledButton(
                onPressed: _entrando
                    ? null
                    : () {
                        if (usuarioControler.text.trim().isEmpty) {
                          _avisar('Por favor, insira um usuário válido.');
                          return;
                        }
                        if (senhaControler.text.isEmpty) {
                          _avisar('Por favor, insira a senha.');
                          return;
                        }
                        fazerLoign();
                      },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(
                    const Color.fromARGB(255, 26, 58, 27),
                  ),
                ),
                child: _entrando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        'Entrar',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TelaCadastro(),
                    ),
                  );
                },
                child: Text(
                  'Cadastre-se',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 26, 58, 27),
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
