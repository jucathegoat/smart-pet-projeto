import 'package:mysql1/mysql1.dart';

import '../models/agendamento_model.dart';
import 'dao.dart';
import '../infra/database/db_configuration.dart';

class AgendamentoDao implements Dao<AgendamentoModel> {
  final DbConfiguration _dbConfiguration;
  AgendamentoDao(this._dbConfiguration);

  @override
  Future<bool> create(AgendamentoModel value) async {
    var result = '';
    return false;
  }

  Future<bool> criarAgendameto(AgendamentoModel value) async {
    final connection = await _dbConfiguration.connection;

    await connection.transaction((txn) async {
      final result = await txn.query(
        'INSERT INTO agenda (cpf, data_agendamento, hora_agendamento, codigo_servico, codigo_pet) VALUES (?, ?, ?, ?, ?)',
        [value.cpf, value.data, value.hora, value.servico, value.pet],
      );
    });

    return true;
  }

  @override
  Future<bool> delete(int id) async {
    var result = await _execQuery('DELETE FROM pet where codigo_pet = ?', [id]);
    return result.affectedRows > 0;
  }

  @override
  Future<List<AgendamentoModel>> findAll() async {
    var result = await _execQuery('SELECT * FROM pet  ', );
    List<AgendamentoModel> _agendamentos = [];
    return result
        .map((r) => AgendamentoModel.fromMap(r.fields))
        .toList()
        .cast<AgendamentoModel>();
  }

  @override
  Future<AgendamentoModel?> findOne(AgendamentoModel value) async {
    var result = await _execQuery(
      'SELECT * FROM pet where nome = ? AND especie = ?',
      [value.cpf, value.pet],
    );

    return result.affectedRows == 0
        ? null
        : AgendamentoModel.fromMap(result.first.fields);
  }

  @override
  Future<bool> update(AgendamentoModel value) async {
    var result = await _execQuery(
      'UPDATE pet set nome = ?, especie = ? where codigo_pet = ? ',
      [value.cpf, value.cpf, value.cpf],
    );
    return result.affectedRows > 0;
  }

  Future<List<Map<String, dynamic>>> findByTutor(String cpfTutor) async {
    var result = await _execQuery(
      '''
SELECT
    p.codigo_pet,
    p.nome AS nome_pet,
    p.especie,
    p.idade,
    s.especialidade,
    a.data_agendamento,
    a.hora_agendamento
FROM pet AS p
INNER JOIN tutela AS t
    ON t.codigo_pet = p.codigo_pet
INNER JOIN agenda AS a
    ON a.codigo_pet = p.codigo_pet
INNER JOIN servico AS s
    ON s.codigo_servico = a.codigo_servico
WHERE t.cpf = ?
ORDER BY p.nome, a.data_agendamento, a.hora_agendamento;

    ''',
      [cpfTutor],
    );
return result.map<Map<String, dynamic>>((row) {
  final data = row['data_agendamento'] as DateTime;
  final hora = row['hora_agendamento'] as Duration;


  final dataFormatada =
      "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}";

  final horaFormatada =
      "${hora.inHours.toString().padLeft(2, '0')}:${(hora.inMinutes % 60).toString().padLeft(2, '0')}:${(hora.inSeconds % 60).toString().padLeft(2, '0')}";

  return {
    'nome_pet': row['nome_pet'],
    'especialidade': row['especialidade'],
    'data': dataFormatada,
    'hora': horaFormatada,
  };
}).toList();

  }

  _execQuery(String SQL, [List? params]) async {
    var connection = await _dbConfiguration.connection;
    return await connection.query(SQL, params);
  }
}
