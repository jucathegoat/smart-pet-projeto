import '../models/usuario_model.dart';
import 'dao.dart';
import '../infra/database/db_configuration.dart';

class UsuarioDao implements Dao<UsuarioModel> {
  final DbConfiguration _dbConfiguration;
  UsuarioDao(this._dbConfiguration);

  @override
  Future<bool> create(UsuarioModel value) async {
    var result = await _execQuery(
      'INSERT INTO tutor (cpf, nome,telefone,endereco,email,usuario,senha,status_conta) VALUES (?,?,?,?,?,?,?,?)',
      [
        value.cpf,
        value.nome,
        value.telefone,
        value.endereco,
        value.email,
        value.usuario,
        value.senha,
        value.status_conta
      ],
    );
    return result.affectedRows > 0;
  }

  @override
  Future<bool> delete(int id) async {
    var result = await _execQuery('DELETE FROM tutor where cpf = ?', [id]);
    return result.affectedRows > 0;
  }

  @override
  Future<List<UsuarioModel>> findAll() async {
    var result = await _execQuery('SELECT * FROM tutor');
    List<UsuarioModel> _usuarios = [];
    return result
        .map((r) => UsuarioModel.fromMap(r.fields))
        .toList()
        .cast<UsuarioModel>();
  }

  @override
  Future<UsuarioModel?> findOne(UsuarioModel value) async {
    var result = await _execQuery('SELECT * FROM tutor where usuario = ? AND senha = ?', [value.usuario, value.senha]);

    return result.affectedRows == 0
        ? null
        : UsuarioModel.fromMap(result.first.fields);
  }

  @override
  Future<bool> update(UsuarioModel value) async {
    var result = await _execQuery(
      'UPDATE tutor set nome = ?, senha = ? where cpf = ? ',
      [value.nome, value.senha, value.cpf],
    );
    return result.affectedRows > 0;
  }

  _execQuery(String SQL, [List? params]) async {
    var connection = await _dbConfiguration.connection;
    return await connection.query(SQL, params);
  }
}
