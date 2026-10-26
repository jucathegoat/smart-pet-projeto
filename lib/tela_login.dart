import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/tela_cadastro.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

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



  Future<void> fazerLoign() async {
    var url = Uri.parse('http://localhost:8080/login/usuario');
    var resposta = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'usuario': usuarioControler.text, 'senha': senhaControler.text}),
    );

    if (!mounted) return;

    if (resposta.statusCode == 200) {
      var dados = jsonDecode(resposta.body);
      if (dados['sucesso'] == true) {
        final cpf = dados['cpf'];
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Login realizado com sucesso!')));

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TelaInicial(usuario: usuarioControler.text, cpf: cpf),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Usuário ou senha incorretos')));
    }
  }

  @override
  void initState() {
    super.initState();
    usuarioControler.clear();
    senhaControler.clear();
  }

  @override

  void dispose(){

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
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Senha",
                  ),
                ),
              ),
              SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  if (usuarioControler.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Por favor, insira um usuário válido.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }
                  fazerLoign();
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(
                    const Color.fromARGB(255, 26, 58, 27),
                  ),
                ),
                child: Text(
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
