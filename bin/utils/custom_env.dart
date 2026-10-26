import 'dart:io';

import 'parser_extenison.dart';
class CustomEnv {
  static Map<String, String> _map = {};
  static String _file = 'server.env';

  CustomEnv._();

  factory CustomEnv.fromFile(String file){
    _file = file;
    return CustomEnv._();
  }

static Future<T> get<T>({required String key}) async {
  if (_map.isEmpty) await _load();
  final value = _map[key];
  if (value == null) {
    throw Exception("Chave '$key' não encontrada no CustomEnv");
  }
  return value.toType(T);
}


static Future<void> _load() async {
  List<String> linhas = (await _readFile()).split('\n');
  _map = {
    for (var l in linhas)
      if (l.contains('=')) l.split('=')[0].trim(): l.split('=')[1].trim()
  };
}

 static Future<String> _readFile() async {
    return await File('server.env').readAsString();
  }
}
