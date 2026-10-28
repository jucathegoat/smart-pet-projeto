import 'package:shelf/shelf.dart';
import 'infra/custom_server.dart';
import 'apis/login.api.dart';
import 'apis/noticias_api.dart';
import 'utils/custom_env.dart';
import 'infra/middleware_interception.dart';
import 'infra/dependency_injector/injects.dart';
import 'apis/usuario_api.dart';
import 'apis/pet_api.dart';
import 'apis/servicos_api.dart';
import 'apis/agendamento_api.dart';

void main() async {
  CustomEnv.fromFile('.env-dev');

  final _di = Injects.initialize();
 
  var cascadeHandler = Cascade()
      .add(_di.get<LoginApi>().getHandler())
      .add(_di.get<BlogApi>().getHandler())
      .add(_di.get<UsuarioApi>().getHandler())
      .add(_di.get<PetApi>().getHandler())
      .add(_di.get<ServicosApi>().getHandler())
      .add(_di.get<AgendamentoApi>().getHandler())
      .handler;

  var handler = Pipeline()
      .addMiddleware(MInterception.contentTypeJson)
      .addMiddleware(MInterception.cors)
      .addMiddleware(logRequests())
      .addHandler(cascadeHandler);

  await CustomServer().initialize(
    handler: handler,
    address: await CustomEnv.get<String>(key: 'server_address'),
    port: await CustomEnv.get<int>(key: 'server_port'),
  );
}
