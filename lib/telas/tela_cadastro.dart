import 'package:flutter_application_1/telas/tela_login.dart';
import 'package:flutter/material.dart';

import '../config/api_config.dart';
import '../servicos/api_cliente.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {

String nome = '';
String cpf = '';
String email = '';
String telefone = '';
String endereco = '';
String usuario = '';
String senha = '';

Future<bool> cadastrarUsuario() async {
  try {
    final dados = await ApiCliente.postJson(
      Uri.parse('${ApiConfig.baseUrl}/usuario'),
      corpo: {
        'nome': nome.trim(),
        'cpf': cpf.trim(),
        'email': email.trim(),
        'telefone': telefone.trim(),
        'endereco': endereco.trim(),
        'usuario': usuario.trim(),
        'senha': senha,
      },
    );

    if (!mounted) return false;

    if (dados['sucesso'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário cadastrado com sucesso!')),
      );
      nome = '';
      cpf = '';
      email = '';
      telefone = '';
      endereco = '';
      usuario = '';
      senha = '';
      return true;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(dados['mensagem']?.toString() ?? 'Erro ao cadastrar usuário'),
      ),
    );
    return false;
  } on ApiException catch (e) {
    ApiCliente.logar(e, StackTrace.current);
    if (!mounted) return false;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.mensagem)),
    );
    return false;
  } catch (e, s) {
    ApiCliente.logar(e, s);
    if (!mounted) return false;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao cadastrar usuário')),
    );
    return false;
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cadastro",
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
          padding: const EdgeInsets.all(34),
          child: Column(
            children: [
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Nome",
                  hintText: "Digite seu nome completo",
                ),
                onChanged: (value) {
                  setState(() {
                    nome = value;
                  });
                },
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "CPF",
                  hintText: "Digite seu CPF",
                ),
                onChanged: (value) {
                  setState(() {
                    cpf = value;
                  });
                },
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Email",
                  hintText: "Digite seu email",
                ),
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Telefone",
                  hintText: "(xx) xxxxx-xxxx",
                ),
                onChanged: (value) {
                  setState(() {
                    telefone = value;
                  });
                },
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Endereço",
                  hintText: "Digite seu endereço",
                ),
                onChanged: (value) {
                  setState(() {
                    endereco = value;
                  });
                },
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Usuario",
                  hintText: "como deseja ser chamado",
                ),
                onChanged: (value) {
                  setState(() {
                    usuario = value;
                  });
                },
              ),
              SizedBox(height: 10),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Senha",
                  hintText: "crie uma senha",
                ),
                onChanged: (value) {
                  setState(() {
                    senha = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: () async {
                      if (nome.trim().isEmpty ||
                          cpf.trim().isEmpty ||
                          usuario.trim().isEmpty ||
                          senha.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Preencha nome, CPF, usuário e senha.',
                            ),
                          ),
                        );
                        return;
                      }
                      final ok = await cadastrarUsuario();
                      if (!ok || !context.mounted) return;
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(
                        const Color.fromARGB(255, 26, 58, 27),
                      ),
                    ),
                    child: Text(
                      'Cadastrar',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 10),
                  FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TelaLogin(),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(
                        const Color.fromARGB(255, 228, 230, 228),
                      ),
                    ),
                    child: Text(
                      'Voltar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
