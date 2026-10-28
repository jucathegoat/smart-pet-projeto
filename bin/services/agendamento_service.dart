import 'generic_service.dart';
import '../models/agendamento_model.dart';
import '../dao/agendamento_dao.dart';

class AgendamentoService implements GenericService<AgendamentoModel> {
  final AgendamentoDao _agendamentoDao;

  new({required this._agendamentoDao});

  @override
  Future<bool> delete(int id) async => _agendamentoDao.delete(id);

  @override
  Future<List<AgendamentoModel>> findAll() async => _agendamentoDao.findAll();

  @override
  Future<AgendamentoModel?> findOne(AgendamentoModel value) async => _agendamentoDao.findOne(value);

  @override
  Future<bool> save(AgendamentoModel value) async {
    if (value.cpf == null) {
      return _agendamentoDao.update(value);
    } else {
      return _agendamentoDao.create(value);
    }
  }

 

  Future<bool> criarAgendameto(AgendamentoModel value) async => _agendamentoDao.criarAgendameto(value);
  Future<List<Map<String, dynamic>>>  findByTutor(String cpfTutor) async => _agendamentoDao.findByTutor(cpfTutor);

}