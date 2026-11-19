class StatusFila {
  static const String emEspera = 'Em espera';
  static const String aguardando = 'Aguardando';
  static const String emAtendimento = 'Em atendimento';
  static const String concluido = 'Concluído';
  static const String cancelado = 'Cancelado';
}

class ItemFila {
  final int id;
  final String nomeCliente;
  final String nomePet;
  final String servico;
  final String status;
  final String statusClass;
  final String posicao;
  final int esperaMinutos;
  final String horarioChegada;
  final String motivoCancelamento;

  ItemFila({
    required this.id,
    required this.nomeCliente,
    required this.nomePet,
    required this.servico,
    required this.status,
    this.statusClass = '',
    this.posicao = '-',
    this.esperaMinutos = 0,
    this.horarioChegada = '',
    this.motivoCancelamento = '',
  });

  // Gera a senha formatada no padrão do sistema:
  // Letra 'A' para agendado ou 'P' para presencial + id formatado (ex: P005, A012)
  String get senha {
    final letra = (statusClass.contains('agendado') || servico.toLowerCase().contains('agend')) ? 'A' : 'P';
    return '$letra${id.toString().padLeft(3, '0')}';
  }

  bool get estaAtivo =>
      status == StatusFila.emEspera ||
      status == StatusFila.aguardando ||
      status == StatusFila.emAtendimento;

  bool get estaEmAtendimento => status == StatusFila.emAtendimento;

  bool get estaFinalizado =>
      status == StatusFila.concluido ||
      status.toLowerCase() == 'concluido' ||
      status.toLowerCase() == 'finalizado';

  factory ItemFila.fromJson(Map<String, dynamic> json) {
    int idVal = 0;
    if (json['id'] != null) {
      idVal = int.tryParse(json['id'].toString()) ?? 0;
    } else if (json['idAtendimento'] != null) {
      idVal = int.tryParse(json['idAtendimento'].toString()) ?? 0;
    }

    int espera = 0;
    if (json['esperaMinutos'] != null) {
      espera = int.tryParse(json['esperaMinutos'].toString()) ?? 0;
    } else if (json['minutosEspera'] != null) {
      espera = int.tryParse(json['minutosEspera'].toString()) ?? 0;
    }

    return ItemFila(
      id: idVal,
      nomeCliente: json['nomeCliente']?.toString() ?? '',
      nomePet: json['nomePet']?.toString() ?? json['pet']?.toString() ?? 'Pet',
      servico: json['servico']?.toString() ?? 'Atendimento Geral',
      status: json['status']?.toString() ?? StatusFila.emEspera,
      statusClass: json['statusClass']?.toString() ?? '',
      posicao: json['posicao']?.toString() ?? '-',
      esperaMinutos: espera,
      horarioChegada: json['horarioChegada']?.toString() ?? '',
      motivoCancelamento: json['motivoCancelamento']?.toString() ?? '',
    );
  }
}
