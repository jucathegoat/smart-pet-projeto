import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Cliente HTTP único da integração Flutter -> Java (SmartPet).
///
/// Centraliza o que hoje está espalhado e divergente entre as telas:
/// * prazo (timeout) em toda chamada;
/// * conversão de qualquer falha de rede numa [ApiException] legível;
/// * leitura do corpo sempre em UTF-8;
/// * mensagem de erro pronta para mostrar ao usuário.
class ApiException implements Exception {
  ApiException(this.mensagem, {this.statusCode, this.causa});

  /// Texto já em português, pronto para um SnackBar.
  final String mensagem;
  final int? statusCode;
  final Object? causa;

  bool get semConexao => statusCode == null;

  @override
  String toString() => mensagem;
}

class ApiCliente {
  ApiCliente._();

  static const Duration prazo = Duration(seconds: 15);

  static Future<Map<String, dynamic>> postJson(
    Uri url, {
    Map<String, dynamic>? corpo,
    Map<String, String>? headers,
    Duration prazo = ApiCliente.prazo,
  }) async {
    final http.Response resposta;
    try {
      resposta = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
              'Accept': 'application/json',
              ...?headers,
            },
            body: jsonEncode(corpo ?? const <String, dynamic>{}),
          )
          .timeout(prazo);
    } catch (e) {
      throw ApiException(_mensagemDeRede(e), causa: e);
    }
    return _decodificar(resposta, url);
  }

  static Future<dynamic> getJson(
    Uri url, {
    Map<String, String>? headers,
    Duration prazo = ApiCliente.prazo,
  }) async {
    final http.Response resposta;
    try {
      resposta = await http
          .get(
            url,
            headers: {'Accept': 'application/json', ...?headers},
          )
          .timeout(prazo);
    } catch (e) {
      throw ApiException(_mensagemDeRede(e), causa: e);
    }
    return _decodificar(resposta, url);
  }

  static Future<Map<String, dynamic>> putJson(
    Uri url, {
    Map<String, dynamic>? corpo,
    Map<String, String>? headers,
    Duration prazo = ApiCliente.prazo,
  }) async {
    final http.Response resposta;
    try {
      resposta = await http
          .put(
            url,
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
              'Accept': 'application/json',
              ...?headers,
            },
            body: jsonEncode(corpo ?? const <String, dynamic>{}),
          )
          .timeout(prazo);
    } catch (e) {
      throw ApiException(_mensagemDeRede(e), causa: e);
    }
    return _decodificar(resposta, url);
  }

  static Future<Map<String, dynamic>> deleteJson(
    Uri url, {
    Map<String, String>? headers,
    Duration prazo = ApiCliente.prazo,
  }) async {
    final http.Response resposta;
    try {
      resposta = await http
          .delete(
            url,
            headers: {'Accept': 'application/json', ...?headers},
          )
          .timeout(prazo);
    } catch (e) {
      throw ApiException(_mensagemDeRede(e), causa: e);
    }
    return _decodificar(resposta, url);
  }

  static Map<String, dynamic> _decodificar(http.Response resposta, Uri url) {
    final corpo = resposta.bodyBytes.isEmpty
        ? ''
        : utf8.decode(resposta.bodyBytes, allowMalformed: true);

    if (resposta.statusCode >= 200 && resposta.statusCode < 300) {
      if (corpo.isEmpty) return <String, dynamic>{};
      final decodificado = jsonDecode(corpo);
      if (decodificado is Map<String, dynamic>) return decodificado;
      return <String, dynamic>{'dados': decodificado};
    }

    String mensagem;
    try {
      final json = jsonDecode(corpo);
      mensagem = (json is Map && json['mensagem'] != null)
          ? json['mensagem'].toString()
          : 'O servidor respondeu ${resposta.statusCode}.';
    } catch (_) {
      mensagem = 'O servidor respondeu ${resposta.statusCode}.';
    }
    throw ApiException(
      mensagem,
      statusCode: resposta.statusCode,
      causa: 'HTTP ${resposta.statusCode} em $url',
    );
  }

  static String _mensagemDeRede(Object erro) {
    if (erro is TimeoutException) {
      return 'O servidor demorou demais para responder. Tente novamente.';
    }
    if (erro is SocketException) {
      return 'Não foi possível conectar ao servidor SmartPet. '
          'Verifique se o backend está no ar e se o endereço está correto.';
    }
    if (erro is http.ClientException) {
      return 'Falha de comunicação com o servidor SmartPet: ${erro.message}';
    }
    return 'Erro inesperado ao chamar a API: $erro';
  }

  /// Detalhe técnico para o log (não vai para o usuário).
  static void logar(Object erro, StackTrace pilha) {
    if (kDebugMode) {
      debugPrint('[SmartPet API] $erro\n$pilha');
    }
  }
}
