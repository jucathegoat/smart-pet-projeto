import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../modelos/item_fila.dart';

class FilaServico {
  final String baseUrl;

  FilaServico({this.baseUrl = AppConfig.baseUrl});

  // Lista todos os itens da fila geral (usado no Painel de TV)
  Future<List<ItemFila>> obterFilaGeral() async {
    try {
      final resposta = await http
          .get(Uri.parse('$baseUrl/api/fila'))
          .timeout(AppConfig.timeout);

      if (resposta.statusCode == 200) {
        final dynamic corpo = jsonDecode(utf8.decode(resposta.bodyBytes));
        if (corpo is List) {
          return corpo.map((e) => ItemFila.fromJson(e as Map<String, dynamic>)).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Lista os atendimentos e senhas específicos do tutor logado (pelo CPF)
  Future<List<ItemFila>> obterFilaDoCliente(String cpf) async {
    final cpfLimpo = cpf.replaceAll(RegExp(r'[^0-9A-Za-z]'), '');
    try {
      final resposta = await http
          .get(Uri.parse('$baseUrl/api/fila/cliente/$cpfLimpo'))
          .timeout(AppConfig.timeout);

      if (resposta.statusCode == 200) {
        final dynamic corpo = jsonDecode(utf8.decode(resposta.bodyBytes));
        if (corpo is List) {
          return corpo.map((e) => ItemFila.fromJson(e as Map<String, dynamic>)).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Cancela uma senha/atendimento com justificativa
  Future<bool> cancelarAtendimento(int id, {String motivo = 'Cancelado pelo cliente no aplicativo'}) async {
    try {
      final resposta = await http
          .post(
            Uri.parse('$baseUrl/api/fila/$id/cancelar'),
            headers: {'Content-Type': 'application/json; charset=utf-8'},
            body: jsonEncode({'motivo': motivo}),
          )
          .timeout(AppConfig.timeout);

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(utf8.decode(resposta.bodyBytes));
        return dados['sucesso'] == true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Adiciona atendimento à fila (caso o tutor faça check-in direto pelo app)
  Future<bool> entrarNaFila({
    required String cliente,
    required String pet,
    required String servico,
  }) async {
    try {
      final resposta = await http
          .post(
            Uri.parse('$baseUrl/api/fila/adicionar'),
            headers: {'Content-Type': 'application/json; charset=utf-8'},
            body: jsonEncode({
              'cliente': cliente,
              'pet': pet,
              'servico': servico,
            }),
          )
          .timeout(AppConfig.timeout);

      return resposta.statusCode == 200 || resposta.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}
