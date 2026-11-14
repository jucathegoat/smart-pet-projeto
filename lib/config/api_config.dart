import 'package:flutter/foundation.dart';

/// Endereços da API Java (SmartPet).
///
/// Regra prática:
/// * emulador Android  -> 10.0.2.2 (o "localhost" do PC visto de dentro do emulador)
/// * celular físico    -> IP da máquina na rede Wi-Fi (use --dart-define)
/// * desktop / web     -> localhost
///
/// Para rodar no celular, informe o IP do PC:
///   flutter run --dart-define=SMARTPET_API_URL=http://192.168.0.10:8080/smartpet
class ApiConfig {
  ApiConfig._();

  /// Sobrescreve tudo (celular físico, servidor remoto, testes).
  static const String _override = String.fromEnvironment('SMARTPET_API_URL');

  static const int portaPadrao = 8080;
  static const String contexto = 'smartpet';

  static String get baseUrl {
    if (_override.isNotEmpty) return _semBarraFinal(_override);

    // Emulador Android: localhost do aparelho não é o PC.
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:$portaPadrao/$contexto';
    }
    return 'http://localhost:$portaPadrao/$contexto';
  }

  static String get avaliacoesUrl => '$baseUrl/api/avaliacoes';

  static String _semBarraFinal(String url) =>
      url.endsWith('/') ? url.substring(0, url.length - 1) : url;
}
