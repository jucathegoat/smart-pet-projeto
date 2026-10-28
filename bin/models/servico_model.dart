class ServicoModel {
   int? codigoServico;
   String? especialidade;
   double? valor;

   ServicoModel();

  ServicoModel.create(this.codigoServico, this.especialidade, this.valor);

  factory ServicoModel.fromMap(Map<String, dynamic> map){
    return ServicoModel.create(
    map['codigo_servico'].toInt() ?? 0,
    map['especialidade'] ?? '',
    map['valor'] ?? 0);
    
  }

  factory ServicoModel.fromRequest(Map map){
    return ServicoModel()
    ..codigoServico = map['codigoServico']
    ..especialidade = map['especialidade']
    ..valor = map['valor'];
  }

    Map<String, dynamic> toMap() {
    return {
      'codigoServico': codigoServico,
      'especialidade': especialidade,
      'valor': valor,
    };
  }

    Map toJson(){
    return{
      'codigoServico': codigoServico,
      'especialidade': especialidade,
      'valor': valor,
    };
    }

  @override
  String toString() {
    return 'ServicoModel(codigoServico: $codigoServico, especialidade:$especialidade, valor: $valor)';
  }
}
