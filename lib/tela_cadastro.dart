import 'package:flutter/material.dart';
import 'package:flutter_application_1/tela_login.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
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
String statusConta = 'ativo';

String? erroNome;
String? erroCpf;
String? erroEmail;
String? erroTelefone;
String? erroEndereco;
String? erroUsuario;
String? erroSenha;


bool validarCPF(String cpf) {
  cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');

  if (cpf.length != 11) return false;

  if (RegExp(r'^(\d)\1{10}$').hasMatch(cpf)) {
    return false;
  }

  int soma = 0;
  for (int i = 0; i < 9; i++) {
    soma += int.parse(cpf[i]) * (10 - i);
  }

  int resto = soma % 11;
  int digito1 = resto < 2 ? 0 : 11 - resto;

  if (int.parse(cpf[9]) != digito1) {
    return false;
  }

  soma = 0;
  for (int i = 0; i < 10; i++) {
    soma += int.parse(cpf[i]) * (11 - i);
  }

  resto = soma % 11;
  int digito2 = resto < 2 ? 0 : 11 - resto;

  return int.parse(cpf[10]) == digito2;
}


Future<void> cadastrarUsuario() async {
  var url = Uri.parse('http://localhost:8080/usuario');
  var resposta = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'nome': nome,
      'cpf': cpf.replaceAll('.', ''),
      'email': email,
      'telefone':telefone,
      'endereco': endereco,
      'usuario': usuario,
      'senha': senha,
      'status_conta':statusConta
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
                  errorText: erroNome,
                ),
                    onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      erroNome = null;
                      nome = value;
                    } else if (!RegExp(r'^[A-Za-zÀ-ÿ\s]+$').hasMatch(value)) {
                      erroNome = 'O nome deve conter apenas letras';
                    } else {
                      erroNome = null;
                      nome = value;
                    }
                  });
                },
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "CPF",
                  hintText: "Digite seu CPF",
                  errorText: erroCpf,
                ),
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty){
                      erroCpf = null;
                      cpf = value;
                    }else if (!validarCPF(value)) {
                      erroCpf = 'CPF inválido, use o formato: 000.000.000-00';
                    } else {
                      erroCpf = null;
                      cpf = value;
                    }
                  });
                },
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Email",
                  hintText: "Digite seu email",
                  errorText: erroEmail,
                ),
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      erroEmail = null;
                      email = value;
                    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      erroEmail = 'Email inválido';
                    } else {
                      erroEmail = null;
                      email = value;
                    }
                  });
                },
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Telefone",
                  hintText: "(xx) xxxxx-xxxx",
                  errorText: erroTelefone,
                ),
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      erroTelefone = null;
                      telefone = value;
                    } else if (!RegExp(r'^\(\d{2}\) \d{4,5}-\d{4}$').hasMatch(value)) {
                      erroTelefone = 'Telefone inválido, use o formato: (xx) xxxxx-xxxx';
                    } else {
                      erroTelefone = null;
                      telefone = value;
                    }
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
                    onPressed: () async{
                      if (nome.isEmpty || cpf.isEmpty || email.isEmpty || telefone.isEmpty || endereco.isEmpty || usuario.isEmpty || senha.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Por favor, preencha todos os campos.')),
                        );
                        return;
                      }
                     await cadastrarUsuario();
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
