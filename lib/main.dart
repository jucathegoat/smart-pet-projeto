import 'package:flutter/material.dart';

import 'tela_agendamento.dart';
import 'loja.dart';
import 'tela_pets.dart';
import 'notificacoes.dart';
import 'tela_login.dart';
import 'tela_avaliacao.dart';

void main() {
  runApp(const MeuApp());
}
class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pet Shop Fila Zero',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),

      home: const TelaLogin(),
    );
  }
}

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key, required this.usuario, required this.cpf});

  final String usuario;
  final String cpf;

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 252, 243),

      appBar: AppBar(
        title: const Text(
          "Pet Shop Fila Zero",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 249, 243, 243),
        centerTitle: true,
      ),

      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 249, 243, 243),
        elevation: 3,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(
                Icons.home,
                color: Color.fromARGB(255, 194, 194, 194),
              ),
              onPressed: () {},
            ),

            IconButton(
              icon: const Icon(
                Icons.shopping_cart,
                color: Color.fromARGB(255, 194, 194, 194),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaLoja()),
                );
              },
            ),

            IconButton(
              icon: const Icon(
                Icons.calendar_month,
                color: Color.fromARGB(255, 194, 194, 194),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  TelaAgendamento(cpf: widget.cpf),
                  ),
                );
              },
            ),

            IconButton(
              icon: const Icon(
                Icons.pets,
                color: Color.fromARGB(255, 194, 194, 194),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TelaPets(cpf: widget.cpf,)),
                );
              },
            ),

            IconButton(
              icon: const Icon(
                Icons.star,
                color: Color.fromARGB(255, 194, 194, 194),
              ),
              tooltip: 'Avaliação',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TelaAvaliacao(servicoId: 1),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      body: Container(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Olá ${widget.usuario}, seja bem-vindo!",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    softWrap: true,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.notifications,
                    color: Color.fromARGB(255, 194, 194, 194),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Notificacoes()),
                    );
                  },
                ),
              ],
            ),
            const Text(
              "O que deseja fazer hoje?",
              style: TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 216, 216, 216),
              ),
            ),
            const SizedBox(height: 25),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width - 20,
                maxHeight: 250,
              ),

              child: CarouselView(
                itemExtent: 350,
                backgroundColor: Colors.blueGrey,

                children: [
                  Image.asset(
                    "assets/images/banner1.png",
                    height: 50,
                    fit: BoxFit.cover,
                  ),

                  Image.asset(
                    "assets/images/banner2.png",
                    height: 50,
                    fit: BoxFit.cover,
                  ),

                  Image.asset(
                    "assets/images/banner3.png",
                    height: 50,
                    fit: BoxFit.cover,
                  ),

                  Image.asset(
                    "assets/images/banner4.png",
                    height: 50,
                    fit: BoxFit.cover,
                  ),

                  Image.asset(
                    "assets/images/banner5.png",
                    height: 50,
                    fit: BoxFit.cover,
                  ),

                  Image.asset(
                    "assets/images/banner6.png",
                    height: 50,
                    fit: BoxFit.cover,
                  ),

                  Image.asset(
                    "assets/images/banner7.png",
                    height: 50,
                    fit: BoxFit.cover,
                  ),

                  Image.asset(
                    "assets/images/banner8.png",
                    height: 50,
                    fit: BoxFit.cover,
                  ),

                  Image.asset(
                    "assets/images/banner9.png",
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}