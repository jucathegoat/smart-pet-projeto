import '../models/produto_model.dart';
import 'dao.dart';
import '../infra/database/db_configuration.dart';

class ProdutoDao implements Dao<ProdutoModel> {
  final DbConfiguration _dbConfiguration;
  ProdutoDao(this._dbConfiguration);

  @override
  Future<bool> create(ProdutoModel value) async {
    var result = '';
    return false;
  }

  Future<bool> criarProduto(ProdutoModel value) async {
    final connection = await _dbConfiguration.connection;

    await connection.transaction((txn) async {
      final result = await txn.query(
        'INSERT INTO produto (idproduto, nome, marca, tipo, estoque, preco, codigo, url) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        [value.idproduto, value.nome, value.marca, value.tipo, value.estoque, value.preco, value.codigo, value.url],
      );
    });

    return true;
  }

  @override
  Future<bool> delete(int id) async {
    var result = await _execQuery('DELETE FROM produto where idproduto = ?', [id]);
    return result.affectedRows > 0;
  }

  @override
  Future<List<ProdutoModel>> findAll() async {
    var result = await _execQuery('SELECT * FROM produto  ', );
    List<ProdutoModel> _produtos = [];
    return result
        .map((r) => ProdutoModel.fromMap(r.fields))
        .toList()
        .cast<ProdutoModel>();
  }

  @override
  Future<ProdutoModel?> findOne(ProdutoModel value) async {
    var result = await _execQuery(
      'SELECT * FROM produto where idproduto = ?',
      [value.idproduto],
    );

    return result.affectedRows == 0
        ? null
        : ProdutoModel.fromMap(result.first.fields);
  }

  @override
  Future<bool> update(ProdutoModel value) async {
    var result = await _execQuery(
      'UPDATE produto set nome = ?, marca = ?, tipo = ?, estoque = ?, preco = ?, codigo = ?, url = ?',
      [value.nome, value.marca, value.tipo, value.estoque, value.preco, value.codigo, value.url],
    );
    return result.affectedRows > 0;
  }

  _execQuery(String SQL, [List? params]) async {
    var connection = await _dbConfiguration.connection;
    return await connection.query(SQL, params);
  }
}
