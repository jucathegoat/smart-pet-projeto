import 'dart:convert';
<<<<<<< HEAD
=======

>>>>>>> 7333d723ef7b14824117c04d411392e18f299962
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class ServerHandler {
  Handler get handler {
    final router = Router();

    router.get('/', (Request req) {
      return Response(
        200,
        body: 'Primeira rota',
        headers: {'content-type': 'text/html'},
      );
    });

    router.get('/ola/mundo/<usuario>', (Request req, String usuario) {
      return Response.ok("Olá mundo $usuario");
    });

    router.get('/query', (Request req) {
      String? nome = req.url.queryParameters['nome'];
      String? idade = req.url.queryParameters['idade'];
      return Response.ok('Query eh: $nome, idade $idade');
    });

    router.post('/login', (Request req) async {
      var result = await req.readAsString();
      Map json = jsonDecode(result);

      var usuario = json['usuario'];
      var senha = json['senha'];

      if (usuario == 'admin' && senha == '123') {
        Map result = {'token': 'token123', 'user_id': 1};
        String jsonResponse = jsonEncode(result);
<<<<<<< HEAD
        return Response.ok(jsonResponse, headers: {'content-type': 'application/json'});
=======
        return Response.ok(jsonResponse,headers: {'content-type':'application/json'});
>>>>>>> 7333d723ef7b14824117c04d411392e18f299962
      } else {
        return Response.forbidden("Acesso negado");
      }
    });

<<<<<<< HEAD
    // ============================================================
    // ROTAS DE AVALIAÇÃO (Integradas com o aplicativo Flutter)
    // ============================================================

    // GET /api/avaliacoes/pendentes -> Retorna atendimentos aguardando avaliação
    router.get('/api/avaliacoes/pendentes', (Request req) {
      List pendentes = [
        {
          'id': 1,
          'servico_id': 1,
          'nome_pet': 'Thor',
          'descricao': 'Banho e Tosa',
        }
      ];

      return Response.ok(
        jsonEncode(pendentes),
        headers: {'content-type': 'application/json'},
      );
    });

    // POST /api/avaliacoes -> Recebe e grava a nota enviada pelo Flutter
    router.post('/api/avaliacoes', (Request req) async {
      try {
        var body = await req.readAsString();
        Map data = jsonDecode(body);

        int servicoId = data['servico_id'];
        int nota = data['nota'];

        print('Avaliação recebida com sucesso! Serviço: $servicoId, Nota: $nota');

        return Response.ok(
          jsonEncode({'mensagem': 'Avaliação registrada com sucesso!'}),
          headers: {'content-type': 'application/json'},
        );
      } catch (e) {
        return Response.internalServerError(
          body: jsonEncode({'erro': 'Falha ao processar avaliação'}),
          headers: {'content-type': 'application/json'},
        );
      }
    });

    return router;
  }
}
=======
    return router;
  }
}
>>>>>>> 7333d723ef7b14824117c04d411392e18f299962
