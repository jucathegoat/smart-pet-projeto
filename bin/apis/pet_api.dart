import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf/src/handler.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/src/middleware.dart';

import '../models/pet_model.dart';
import '../services/pet_service.dart';
import 'api.dart';

class PetApi extends Api {
  final PetService _petService;

  PetApi(this._petService);

  @override
  Handler getHandler({List<Middleware>? middlewares, bool isSecurity = false}) {
    final router = Router();

    // Cadastrar pet associado a um tutor
    router.post('/cadastrar/pet', (Request req) async {
      try {
        final body = await req.readAsString();

        if (body.isEmpty) {
          return Response(
            400,
            body: jsonEncode({'erro': 'O corpo da requisição está vazio.'}),
          );
        }

        final data = jsonDecode(body) as Map<String, dynamic>;

        if (data['cpf'] == null) {
          return Response(
            400,
            body: jsonEncode({'erro': 'O CPF do tutor é obrigatório.'}),
          );
        }

        final pet = PetModel.fromRequest(data);
        final cpfTutor = data['cpf'].toString();

        await _petService.saveWithTutor(pet, cpfTutor);

        return Response(
          201,
          body: jsonEncode({
            'sucesso': true,
            'mensagem': 'Pet cadastrado com sucesso!',
          }),
          headers: {'content-type': 'application/json'},
        );
      } on FormatException {
        return Response(
          400,
          body: jsonEncode({'erro': 'JSON ou CPF inválido.'}),
          headers: {'content-type': 'application/json'},
        );
      } catch (e, stackTrace) {
        print('ERRO AO CADASTRAR PET: $e');
        print(stackTrace);

        return Response(
          500,
          body: jsonEncode({
            'sucesso': false,
            'erro': 'Erro ao cadastrar o pet.',
            'detalhes': e.toString(),
          }),
          headers: {'content-type': 'application/json'},
        );
      }
    });

    router.get('/tutor/<cpfTutor>/pets', (Request req, String cpfTutor) async {
      final cpf = cpfTutor;

      if (cpf == '') {
        return Response(
          400,
          body: jsonEncode({'sucesso': false, 'mensagem': 'CPF inválido.'}),
        );
      }

      final pets = await _petService.findByTutor(cpf);

      return Response.ok(jsonEncode({'sucesso': true, 'pets': pets}));
    });

    router.delete('/deletar/pet/<codigoPet>', (
      Request req,
      String codigoPet,
    ) async {
      try {
        final id = int.parse(codigoPet);
        var sucessoDel = await _petService.deletePet(id);

        if (sucessoDel) {
          return Response(204);
        } else {
          return Response.notFound('Pet $id não encontrado');
        }
      } catch (e) {
        return Response.internalServerError(body: 'Erro: $e');
      }
    });

    return creatHandler(
      router: router,
      isSecurity: isSecurity,
      middlewares: middlewares,
    );
  }
}
