import 'package:flutter/foundation.dart';

class ApiConfig {
  ApiConfig._();

  // Physical phone: pass --dart-define=SMARTPET_API_URL=http://<IP-DO-PC>:8080/smartpet
  static const String _override = String.fromEnvironment('SMARTPET_API_URL');
  static String get baseUrl => _override.isNotEmpty
      ? _override
      : defaultTargetPlatform == TargetPlatform.android
          ? 'http://10.0.2.2:8080/smartpet'
          : 'http://localhost:8080/smartpet';
  static String get avaliacoesUrl => '$baseUrl/api/avaliacoes';
}
