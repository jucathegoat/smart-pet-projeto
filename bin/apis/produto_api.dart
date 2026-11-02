import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf/src/handler.dart';
import 'package:shelf_router/shelf_router.dart';

import '../models/produto_model.dart';
import '../services/produto_service.dart';

import 'package:shelf/src/middleware.dart';


import 'api.dart';

class ProdutoApi extends Api {
  final ProdutoService _produtoService;
  ProdutoApi(this._produtoService);

  @override
  Handler getHandler({List<Middleware>? middlewares, bool isSecurity = false}) {
    final router = Router();

    router.post('/novo/produto', (Request req) async {
      var body = await req.readAsString();
      if (body.isEmpty) return Response(400);
      var produto = ProdutoModel.fromRequest(jsonDecode(body));
      var result = await _produtoService.criarProduto(produto);
      return result ? Response(201) : Response(500);
    });

    router.get('/produto', (Request req) async {

      final produto = await _produtoService.findAll();

      return Response.ok(jsonEncode({'sucesso': true, 'produtos': produto}));
    });


    return creatHandler(
      router: router,
      isSecurity: isSecurity,
      middlewares: middlewares,
    );
  }
}
