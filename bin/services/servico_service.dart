import 'generic_service.dart';
import '../models/servico_model.dart';
import '../dao/servico_dao.dart';

class ServicoService implements GenericService<ServicoModel> {
  final ServicoDao _servicoDao;

  new({required this._servicoDao});

  @override
  Future<bool> delete(int id) async => _servicoDao.delete(id);

  @override
  Future<List<ServicoModel>> findAll() async => _servicoDao.findAll();

  @override
  Future<ServicoModel?> findOne(ServicoModel value) async => _servicoDao.findOne(value);

  @override
  Future<bool> save(ServicoModel value) async {
    if (value.codigoServico == null) {
      return _servicoDao.update(value);
    } else {
      return _servicoDao.create(value);
    }
  }
}
