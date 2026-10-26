import 'package:flutter/material.dart';
import 'package:flutter_application_1/tela_novo_agendamento.dart';


class TelaAgendamento extends StatefulWidget {
  const TelaAgendamento({super.key});

  @override
  TelaAgendamentoState createState() => TelaAgendamentoState();
}

class TelaAgendamentoState extends State<TelaAgendamento> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendamentos'),
        backgroundColor: Color.fromARGB(255, 249, 243, 243),
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Text('Não há nenhum agendamento', textAlign: TextAlign.center),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>const TelaNovoAgendamento(),
            ),
          );
        },
        shape: CircleBorder(
          side: BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
