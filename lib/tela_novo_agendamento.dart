import 'package:flutter/material.dart';

class TelaNovoAgendamento extends StatefulWidget {
  const TelaNovoAgendamento({super.key});

  @override
  State<TelaNovoAgendamento> createState() => _TelaNovoAgendamentoState();
}
String cliente = '';
String servico = '';
String pet = '';
String telefone = '';
String data = '';



class _TelaNovoAgendamentoState extends State<TelaNovoAgendamento> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Novo Agendamento",
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
                onChanged: (value) {
                  setState(() {
                    cliente = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Cliente",
                  hintText: "Digite seu nome completo",
                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Serviço",
                ),
                items: const [
                  DropdownMenuItem(
                    value: "Banho e Tosa",
                    child: Text("Banho e Tosa"),
                  ),
                  DropdownMenuItem(
                    value: "Consulta Veterinária",
                    child: Text("Consulta Veterinária"),
                  ),
                  DropdownMenuItem(
                    value: "Vacinação",
                    child: Text("Vacinação"),
                  ),
                  DropdownMenuItem(
                    value: "Exame Geral",
                    child: Text("Exame Geral"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    servico = value ?? '';
                  });
                },
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Pet",
                  hintText: "Digite o nome do seu pet",
                ),
                onChanged: (value) {
                  setState(() {
                    pet = value;
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
                  labelText: "Data",
                  hintText: "Digite a data que deseja agendar",
                ),
                onChanged: (value) {
                  setState(() {
                    data = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(Color.fromARGB(255, 26, 58, 27)),
                    ),
                    onPressed: () {
                      // Lógica para salvar o agendamento
                    },
                    child: Text("Agendar"),
                  ),
                  SizedBox(width: 10),
                  FilledButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(Color.fromARGB(255, 228, 230, 228)),
                    ),
                    onPressed: () {
                     Navigator.pop(context);  
                    },
                    child: Text("Cancelar",
                    style: TextStyle(color: Colors.black),
                    )
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
