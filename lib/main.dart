import 'package:flutter/material.dart';

import 'tela_agendamento.dart';
import 'loja.dart';
import 'tela_pets.dart';
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
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeContent(usuario: widget.usuario),
      const TelaLoja(),
      TelaAgendamento(cpf: widget.cpf),
      TelaPets(cpf: widget.cpf),
      const TelaAvaliacao(servicoId: 1),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        indicatorColor: Colors.indigo.withValues(alpha: 0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Color.fromARGB(255, 26, 58, 27)),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart, color: Color.fromARGB(255, 26, 58, 27)),
            label: "Loja",
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month, color: Color.fromARGB(255, 26, 58, 27)),
            label: "Agenda",
          ),
          NavigationDestination(
            icon: Icon(Icons.pets_outlined),
            selectedIcon: Icon(Icons.pets, color: Color.fromARGB(255, 26, 58, 27)),
            label: "Pets",
          ),
          NavigationDestination(
            icon: Icon(Icons.star_outline),
            selectedIcon: Icon(Icons.star, color: Color.fromARGB(255, 26, 58, 27)),
            label: "Avaliação",
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 249, 243, 243),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final String usuario;
  const HomeContent({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Olá $usuario, seja bem-vindo!",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  softWrap: true,
                ),
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
                Image.asset("assets/images/banner1.png", fit: BoxFit.cover),
                Image.asset("assets/images/banner2.png", fit: BoxFit.cover),
                Image.asset("assets/images/banner3.png", fit: BoxFit.cover),
                Image.asset("assets/images/banner4.png", fit: BoxFit.cover),
                Image.asset("assets/images/banner5.png", fit: BoxFit.cover),
                Image.asset("assets/images/banner6.png", fit: BoxFit.cover),
                Image.asset("assets/images/banner7.png", fit: BoxFit.cover),
                Image.asset("assets/images/banner8.png", fit: BoxFit.cover),
                Image.asset("assets/images/banner9.png", fit: BoxFit.cover),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
