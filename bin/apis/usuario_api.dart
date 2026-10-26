import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf/src/handler.dart';
import 'package:shelf_router/shelf_router.dart';

import '../models/usuario_model.dart';
import '../services/usuario_service.dart';

import 'package:shelf/src/middleware.dart';


import 'api.dart';

class UsuarioApi extends Api {
  final UsuarioService _usuarioService;
  UsuarioApi(this._usuarioService);

  @override
  Handler getHandler({List<Middleware>? middlewares, bool isSecurity = false}) {
    final router = Router();

    router.post('/usuario', (Request req) async {
      var body = await req.readAsString();
      if (body.isEmpty) return Response(400);
      var usuario = UsuarioModel.fromRequest(jsonDecode(body));
      var result = await _usuarioService.save(usuario);
      return result ? Response(201) : Response(500);
    });

    router.post('/login/usuario', (Request req) async {
      var body = await req.readAsString();
      if (body.isEmpty) return Response(400);

      var usuario = UsuarioModel.fromRequest(jsonDecode(body));
      var result = await _usuarioService.findOne(usuario);

      if (result == null) {
        return Response.notFound('Usuário ou senha inválidos');
      }

      return Response.ok(jsonEncode({'sucesso': true, 'nome':result.nome, 'cpf':result.cpf}));
    });


    return creatHandler(
      router: router,
      isSecurity: isSecurity,
      middlewares: middlewares,
    );
  }
}
