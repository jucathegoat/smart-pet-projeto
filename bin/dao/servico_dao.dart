import '../models/servico_model.dart';
import 'dao.dart';
import '../infra/database/db_configuration.dart';

class ServicoDao implements Dao<ServicoModel> {
  final DbConfiguration _dbConfiguration;
  ServicoDao(this._dbConfiguration);

  @override
  Future<bool> create(ServicoModel value) async {
    var result = await _execQuery(
      'INSERT INTO servico (codigo_servico, especialidade,valor) VALUES (?,?,?)',
      [
        value.codigoServico,
        value.especialidade,
        value.valor,
      ],
    );
    return result.affectedRows > 0;
  }

  @override
  Future<bool> delete(int id) async {
    var result = await _execQuery('DELETE FROM servico where cpf = ?', [id]);
    return result.affectedRows > 0;
  }

  @override
  Future<List<ServicoModel>> findAll() async {
    var result = await _execQuery('SELECT * FROM servico');
    List<ServicoModel> _servicos = [];
    return result
        .map((r) => ServicoModel.fromMap(r.fields))
        .toList()
        .cast<ServicoModel>();
  }

  @override
  Future<ServicoModel?> findOne(ServicoModel value) async {
    var result = await _execQuery('SELECT * FROM servico where codigo_servico = ?', [value.codigoServico]);

    return result.affectedRows == 0
        ? null
        : ServicoModel.fromMap(result.first.fields);
  }

  @override
  Future<bool> update(ServicoModel value) async {
    var result = await _execQuery(
      'UPDATE servico set valor = ? where codigo_servico = ? ',
      [value.valor, value.codigoServico],
    );
    return result.affectedRows > 0;
  }

  _execQuery(String SQL, [List? params]) async {
    var connection = await _dbConfiguration.connection;
    return await connection.query(SQL, params);
  }
}
