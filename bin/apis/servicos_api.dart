import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf/src/handler.dart';
import 'package:shelf_router/shelf_router.dart';

import '../models/servico_model.dart';
import '../services/servico_service.dart';

import 'package:shelf/src/middleware.dart';


import 'api.dart';

class ServicosApi extends Api {
  final ServicoService _servicoService;
  ServicosApi(this._servicoService);

  @override
  Handler getHandler({List<Middleware>? middlewares, bool isSecurity = false}) {
    final router = Router();

    router.post('/cadastrar/servico', (Request req) async {
      var body = await req.readAsString();
      if (body.isEmpty) return Response(400);
      var usuario = ServicoModel.fromRequest(jsonDecode(body));
      var result = await _servicoService.save(usuario);
      return result ? Response(201) : Response(500);
    });

    router.get('/servicos', (Request req) async {

      final servicos = await _servicoService.findAll();

      return Response.ok(jsonEncode({'sucesso': true, 'servicos': servicos}));
    });

    return creatHandler(
      router: router,
      isSecurity: isSecurity,
      middlewares: middlewares,
    );
  }
}
