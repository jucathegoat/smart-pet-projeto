import 'generic_service.dart';
import '../models/pet_model.dart';
import '../dao/pet_dao.dart';

class PetService implements GenericService<PetModel> {
  final PetDao _petDao;

  new({required this._petDao});

  @override
  Future<bool> delete(int id) async => _petDao.delete(id);

  @override
  Future<List<PetModel>> findAll() async => _petDao.findAll();

  @override
  Future<PetModel?> findOne(PetModel value) async => _petDao.findOne(value);

  @override
  Future<bool> save(PetModel value) async {
    if (value.nome == null) {
      return _petDao.update(value);
    } else {
      return _petDao.create(value);
    }
  }
  Future<bool> saveWithTutor(
    PetModel value, cpfTutor) async {
  return _petDao.createWithTutor(value, cpfTutor);
}
  Future<List<Map<String, dynamic>>> findByTutor(String cpfTutor) async {
  return await _petDao.findByTutor(cpfTutor);
}

Future<bool> deletePet(int codigoPet) async => _petDao.deletePet(codigoPet);
}