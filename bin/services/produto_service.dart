import 'generic_service.dart';
import '../models/produto_model.dart';
import '../dao/produto_dao.dart';

class ProdutoService implements GenericService<ProdutoModel> {
  final ProdutoDao _produtoDao;

  new({required this._produtoDao});

  @override
  Future<bool> delete(int id) async => _produtoDao.delete(id);

  @override
  Future<List<ProdutoModel>> findAll() async => _produtoDao.findAll();

  @override
  Future<ProdutoModel?> findOne(ProdutoModel value) async => _produtoDao.findOne(value);

  @override
  Future<bool> save(ProdutoModel value) async {
    if (value.idproduto == null) {
      return _produtoDao.create(value);
    } else {
      return _produtoDao.update(value);
    }
  }

 

  Future<bool> criarProduto(ProdutoModel value) async => _produtoDao.criarProduto(value);

}