import 'generic_service.dart';
import '../models/usuario_model.dart';
import '../dao/usuario_dao.dart';

class UsuarioService implements GenericService<UsuarioModel> {
  final UsuarioDao _usuarioDao;

  new({required this._usuarioDao});

  @override
  Future<bool> delete(int id) async => _usuarioDao.delete(id);

  @override
  Future<List<UsuarioModel>> findAll() async => _usuarioDao.findAll();

  @override
  Future<UsuarioModel?> findOne(UsuarioModel value) async => _usuarioDao.findOne(value);

  @override
  Future<bool> save(UsuarioModel value) async {
    if (value.cpf == null) {
      return _usuarioDao.update(value);
    } else {
      return _usuarioDao.create(value);
    }
  }
}
