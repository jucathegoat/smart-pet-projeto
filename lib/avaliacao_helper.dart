import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> enviarAvaliacao(BuildContext context, int servicoId, int nota) async {
 
  final url = Uri.parse('http://localhost:8086/api/avaliacoes'); 

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'servico_id': servicoId,
        'nota': nota, // 1 (Ruim), 2 (Bom), 3 (Excelente)
      }),
    );

    // Garante que o widget/diÃƒÂ¡logo ainda estÃƒÂ¡ ativo na tela antes de interagir com o contexto
    if (!context.mounted) return;

    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.of(context).pop(); // Fecha o pop-up de avaliaÃƒÂ§ÃƒÂ£o
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Obrigado pela sua avaliaÃƒÂ§ÃƒÂ£o!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar (${response.statusCode}). Tente novamente.')),
      );
    }
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro de conexÃƒÂ£o: $e')),
    );
  }
}

void mostrarPopupAvaliacao(BuildContext context, int servicoId) {
  showDialog(
    context: context,
    barrierDismissible: false, // Impede fechar clicando fora sem avaliar
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Como vocÃƒÂª avalia nosso atendimento?'),
        content: const Text('O seu atendimento foi concluÃƒÂ­do. Por favor, avalie a sua experiÃƒÂªncia:'),
        actions: [
          TextButton(
            onPressed: () => enviarAvaliacao(dialogContext, servicoId, 1),
            child: const Text('Ruim', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => enviarAvaliacao(dialogContext, servicoId, 2),
            child: const Text('Bom', style: TextStyle(color: Colors.orange)),
          ),
          ElevatedButton(
            onPressed: () => enviarAvaliacao(dialogContext, servicoId, 3),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Excelente', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}