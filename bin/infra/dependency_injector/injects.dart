import 'dependency_injector.dart';
import '../security/security_service.dart';
import '../security/security_service_imp.dart';
import '../../apis/login.api.dart';
import '../../apis/noticias_api.dart';
import '../../services/noticias_service.dart';
import '../../models/noticia_model.dart';
import '../../services/generic_service.dart';
import '../database/db_configuration.dart';
import '../database/mysql_db_configuration.dart';
import '../../dao/usuario_dao.dart';
import '../../dao/pet_dao.dart';
import '../../services/usuario_service.dart';
import '../../services/pet_service.dart';
import '../../apis/usuario_api.dart';
import '../../apis/pet_api.dart';

class Injects {
  static DependencyInjector initialize() {
    var di = DependencyInjector();

    // Registra o serviço de segurança
    di.register<SecurityService>(() => SecurityServiceImp());

    // LoginApi depende de SecurityService
    di.register<LoginApi>(() => LoginApi(di.get<SecurityService>()));

    // Serviço genérico de notícias
    di.register<GenericService<NoticiaModel>>(() => NoticiaService());

    // BlogApi também depende de SecurityService
    di.register<BlogApi>(() => BlogApi(di.get<GenericService<NoticiaModel>>()));

    di.register<DbConfiguration>(()=> MysqlDbConfiguration());

    di.register<UsuarioDao>(()=> UsuarioDao(di<DbConfiguration>()));
    di.register<UsuarioService>(()=>UsuarioService(usuarioDao: di<UsuarioDao>()));
    di.register<UsuarioApi>(()=> UsuarioApi(di<UsuarioService>()));

    di.register<PetDao>(()=> PetDao(di<DbConfiguration>()));
    di.register<PetService>(()=>PetService(petDao: di<PetDao>()));
    di.register<PetApi>(()=> PetApi(di<PetService>()));
    return di;
  }
}
