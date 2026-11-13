import 'generic_service.dart';
import '../models/noticia_model.dart';
import '../utils/list_extension.dart';

class NoticiaService implements GenericService<NoticiaModel> {
  final List<NoticiaModel> _fakeDB = [];

  @override
 Future< bool> delete(int id) async{
    _fakeDB.removeWhere((e) => e.id == id);
    return true;
  }

  @override
  Future<List<NoticiaModel>> findAll() async {
    return _fakeDB;
  }

  @override
  Future<NoticiaModel> findOne(NoticiaModel id) async{
    return _fakeDB.firstWhere((e) => e.id == id);
  }

  @override
  Future<bool> save(NoticiaModel value)async {
    NoticiaModel? model = _fakeDB.firstWhereOrNull(
      (e) => e.id == value.id,
    );
    if (model == null){
      _fakeDB.add(value);
    }else{
      _fakeDB.indexOf(model);
      var index = _fakeDB.indexOf(model);
      _fakeDB[index] = value;
    }

    return true;
  }
}
