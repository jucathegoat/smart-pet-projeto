import 'package:flutter/material.dart';

import 'tela_agendamento.dart';
import 'loja.dart';
import 'tela_pets.dart';
import 'tela_login.dart';
import 'tela_avaliacao.dart';
import 'telas/tela_minha_senha.dart';
import 'telas/tela_painel_fila.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartPet - Gestão & Filas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 26, 58, 27),
        ),
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
  int _navIndex = 0;

  late final List<Widget> _screens;
  late final List<String> _titulos;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeContent(
        usuario: widget.usuario,
        onNavegarPara: (index) {
          setState(() {
            _selectedIndex = index;
            _navIndex = 0;
          });
        },
      ),
      TelaMinhaSenha(cpf: widget.cpf, usuario: widget.usuario), // 1
      const TelaPainelFila(), // 2
      TelaAgendamento(cpf: widget.cpf), // 3
      const TelaLoja(), // 4
      TelaPets(cpf: widget.cpf), // 5
      TelaAvaliacao(cpf: widget.cpf), // 6
    ];

    _titulos = [
      'SmartPet',
      'Minha Senha & Fila',
      'Painel da Recepção (TV)',
      'Agendamento',
      'Loja de Produtos',
      'Meus Pets',
      'Avaliação de Serviços',
    ];
  }

  void _onItemTapped(int navIndex) {
    setState(() {
      _navIndex = navIndex;

      switch (navIndex) {
        case 0:
          _selectedIndex = 0; // Home
          break;
        case 1:
          _selectedIndex = 4; // Loja
          break;
        case 2:
          _selectedIndex = 3; // Agendamento
          break;
        case 3:
          _selectedIndex = 5; // Pets
          break;
        case 4:
          _selectedIndex = 6; // Avaliar
          break;
      }
    });
  }

  void _sair() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sair do App?'),
        content: const Text('Deseja realmente desconectar de sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TelaLogin()),
              );
            },
            child: const Text('Sair', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          _titulos[_selectedIndex],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 249, 243, 243),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Desconectar',
            icon: const Icon(Icons.logout, color: Colors.grey),
            onPressed: _sair,
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        onDestinationSelected: _onItemTapped,
        indicatorColor: const Color.fromARGB(
          255,
          26,
          58,
          27,
        ).withValues(alpha: 0.18),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(
              Icons.home,
              color: Color.fromARGB(255, 26, 58, 27),
            ),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(
              Icons.shopping_bag,
              color: Color.fromARGB(255, 26, 58, 27),
            ),
            label: "Loja",
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(
              Icons.calendar_month,
              color: Color.fromARGB(255, 26, 58, 27),
            ),
            label: "Agendar",
          ),
          NavigationDestination(
            icon: Icon(Icons.pets_outlined),
            selectedIcon: Icon(
              Icons.pets,
              color: Color.fromARGB(255, 26, 58, 27),
            ),
            label: "Pets",
          ),
          NavigationDestination(
            icon: Icon(Icons.star_outline),
            selectedIcon: Icon(
              Icons.star,
              color: Color.fromARGB(255, 26, 58, 27),
            ),
            label: "Avaliar",
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 249, 243, 243),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final String usuario;
  final void Function(int index) onNavegarPara;

  const HomeContent({
    super.key,
    required this.usuario,
    required this.onNavegarPara,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Olá $usuario, seja bem-vindo!",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Acompanhe seus pets, senhas e serviços:",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // ATALHOS RÁPIDOS PARA FILAS E SENHAS
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => onNavegarPara(1), // Aba Minha Senha
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 238, 245, 238),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color.fromARGB(255, 180, 210, 180),
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.confirmation_number,
                          color: Color.fromARGB(255, 26, 58, 27),
                          size: 32,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Minha Senha',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Ver status e posição',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () => onNavegarPara(2), // Aba Painel TV
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1B2E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.tv, color: Colors.amber, size: 32),
                        SizedBox(height: 10),
                        Text(
                          'Painel TV',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Fila da recepção ao vivo',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Text(
            'Destaques SmartPet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width - 20,
              maxHeight: 220,
            ),
            child: CarouselView(
              itemExtent: 320,
              backgroundColor: Colors.blueGrey.shade100,
              children: [
                Image.asset(
                  "assets/images/banner1.png",
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.pets, size: 48, color: Colors.indigo),
                  ),
                ),
                Image.asset(
                  "assets/images/banner2.png",
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.pets, size: 48, color: Colors.indigo),
                  ),
                ),
                Image.asset(
                  "assets/images/banner3.png",
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.pets, size: 48, color: Colors.indigo),
                  ),
                ),
                Image.asset(
                  "assets/images/banner4.png",
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.pets, size: 48, color: Colors.indigo),
                  ),
                ),
                Image.asset(
                  "assets/images/banner5.png",
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.pets, size: 48, color: Colors.indigo),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
