import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf/src/handler.dart';
import 'package:shelf_router/shelf_router.dart';

import '../models/agendamento_model.dart';
import '../services/agendamento_service.dart';

import 'package:shelf/src/middleware.dart';


import 'api.dart';

class AgendamentoApi extends Api {
  final AgendamentoService _agendamentoService;
  AgendamentoApi(this._agendamentoService);

  @override
  Handler getHandler({List<Middleware>? middlewares, bool isSecurity = false}) {
    final router = Router();

    router.post('/novo/agendamento', (Request req) async {
      var body = await req.readAsString();
      if (body.isEmpty) return Response(400);
      var agendamento = AgendamentoModel.fromRequest(jsonDecode(body));
      var result = await _agendamentoService.criarAgendameto(agendamento);
      return result ? Response(201) : Response(500);
    });

    router.get('/agendamentos/<cpfTutor>', (Request req, String cpfTutor) async {
            final cpf = cpfTutor;

      if (cpf == '') {
        return Response(
          400,
          body: jsonEncode({'sucesso': false, 'mensagem': 'CPF inválido.'}),
        );
      }

      final agendamentos = await _agendamentoService.findByTutor(cpf);

      return Response.ok(jsonEncode({'sucesso': true, 'agendamentos': agendamentos}));
    });


    return creatHandler(
      router: router,
      isSecurity: isSecurity,
      middlewares: middlewares,
    );
  }
}
