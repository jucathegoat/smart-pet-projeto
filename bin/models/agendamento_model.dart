class AgendamentoModel {
  String? cpf;
  int? servico;
  int? pet;
  String? data;
  String? hora;
  String? status;

  AgendamentoModel();

  AgendamentoModel.create(this.cpf, this.servico, this.pet, this.data, this.hora, this.status);

  factory AgendamentoModel.fromMap(Map<String, dynamic> map) {
    return AgendamentoModel.create(
      map['cpf'] ?? '',
      map['servico'] ?? '',
      map['pet'] ?? '',
      map['data']?? '',
      map['hora']?? '',
      map['status']?? '',
    );
  }

  factory AgendamentoModel.fromRequest(Map<String, dynamic> map) {
    return AgendamentoModel()
    ..cpf = map['cpf']
    ..servico = map['servico']
    ..pet = map['pet']
    ..data = map['data']
    ..hora = map['hora']
    ..status = map['status'];
  }

  Map<String, dynamic> toMap() {
    return {
      'cpf': cpf,
      'servico': servico,
      'pet': pet,
      'data': data,
      'hora': hora,
      'status': status,
    };
  }

  @override
  String toString() {
    return 'agendamentoModel(cpf:$cpf, servico: $servico, pet: $pet,data: $data, hora: $hora, status: $status)';
  }
}
