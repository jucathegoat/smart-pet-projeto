import 'package:flutter/material.dart';
import 'package:flutter_application_1/tela_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


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

Future<void> cadastrarUsuario() async {
  var url = Uri.parse('http://localhost:8080/usuario');
  var resposta = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'nome': nome,
      'cpf': cpf,
      'email': email,
      'endereco': endereco,
      'usuario': usuario,
      'senha': senha,
    }),
  );

  if (!mounted) return;

  if (resposta.statusCode == 201 || resposta.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Usuario cadastrado com sucesso!')),
    );
    nome = '';
    cpf = '';
    email = '';
    telefone = '';
    endereco = '';
    usuario = '';
    senha = '';
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao cadastrar usuário')),
    );
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
                    onPressed: () {
                      cadastrarUsuario();
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
