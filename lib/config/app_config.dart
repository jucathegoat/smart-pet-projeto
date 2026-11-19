class AppConfig {
  // Endereço base da API backend (Spring Boot rodando na porta 8080)
  static const String baseUrl = 'http://localhost:8080';

  // Timeout padrão para requisições HTTP
  static const Duration timeout = Duration(seconds: 10);
}
