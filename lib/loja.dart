import 'package:flutter/material.dart';

class TelaLoja extends StatelessWidget{
  const TelaLoja({super.key});

  @override

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        backgroundColor: Color.fromARGB(255, 249, 243, 243),
        foregroundColor: Colors.black,
      ),
      body: const Center(
        child: Text('Não há Produtos Disponíveis')
      ),
    );
  }
}