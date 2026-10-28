import 'package:mysql1/mysql1.dart';

import '../models/pet_model.dart';
import 'dao.dart';
import '../infra/database/db_configuration.dart';

class PetDao implements Dao<PetModel> {
  final DbConfiguration _dbConfiguration;
  PetDao(this._dbConfiguration);

  @override
  Future<bool> create(PetModel value) async {
    var result = await _execQuery(
      'INSERT INTO tutor (cpf, email,nome,endereco,usuario,senha) VALUES (?,?,?,?,?,?)',
      [value.especie, value.nome, value.idade],
    );
    return result.affectedRows > 0;
  }

Future<bool> deletePet(int codigoPet) async {
  try {
    await _execQuery(
      'DELETE FROM tutela WHERE codigo_pet = ?;',
      [codigoPet],
    );

    await _execQuery(
      'DELETE FROM agenda WHERE codigo_pet = ?;',
      [codigoPet],
    );

    final result = await _execQuery(
      'DELETE FROM pet WHERE codigo_pet = ?;',
      [codigoPet],
    );

    return result.affectedRows > 0;

  } catch (e) {
    print("Erro ao deletar pet: $e");
    return false;
  }
}



  Future<bool> createWithTutor(PetModel value, String cpfTutor) async {
    final connection = await _dbConfiguration.connection;

    await connection.transaction((txn) async {
      final result = await txn.query(
        'INSERT INTO pet (especie, nome, idade) VALUES (?, ?, ?)',
        [value.especie, value.nome, value.idade],
      );

      final codigoPet = result.insertId;

      if (codigoPet == null || codigoPet == 0) {
        throw Exception('Não foi possível obter o código do pet.');
      }

      await txn.query('INSERT INTO tutela (codigo_pet, cpf) VALUES (?, ?)', [
        codigoPet,
        cpfTutor,
      ]);
    });

    return true;
  }

  Future<List<Map<String, dynamic>>> findByTutor(String cpfTutor) async {
    var result = await _execQuery(
      '''
    SELECT
      p.codigo_pet,
      p.nome,
      p.especie,
      p.idade
    FROM pet p
    INNER JOIN tutela t
      ON t.codigo_pet = p.codigo_pet
    WHERE t.cpf = ?
    ORDER BY p.nome
    ''',
      [cpfTutor],
    );
    return result
        .map<Map<String, dynamic>>(
          (row) => {
            'codigoPet': row['codigo_pet'],
            'nome': row['nome'],
            'especie': row['especie'],
            'idade': row['idade'],
          },
        )
        .toList();
  }

  @override
  Future<bool> delete(int id) async {
    var result = await _execQuery('DELETE FROM pet where codigo_pet = ?', [id]);
    return result.affectedRows > 0;
  }

  @override
  Future<List<PetModel>> findAll() async {
    var result = await _execQuery('SELECT * FROM pet  ');
    List<PetModel> _pets = [];
    return result
        .map((r) => PetModel.fromMap(r.fields))
        .toList()
        .cast<PetModel>();
  }

  @override
  Future<PetModel?> findOne(PetModel value) async {
    var result = await _execQuery(
      'SELECT * FROM pet where nome = ? AND especie = ?',
      [value.nome, value.especie],
    );

    return result.affectedRows == 0
        ? null
        : PetModel.fromMap(result.first.fields);
  }

  @override
  Future<bool> update(PetModel value) async {
    var result = await _execQuery(
      'UPDATE pet set nome = ?, especie = ? where codigo_pet = ? ',
      [value.nome, value.especie, value.idade],
    );
    return result.affectedRows > 0;
  }

  _execQuery(String SQL, [List? params]) async {
    var connection = await _dbConfiguration.connection;
    return await connection.query(SQL, params);
  }
}
