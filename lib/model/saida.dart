import 'package:cloud_firestore/cloud_firestore.dart';

class Saida {
  final String uid;
  final String nomeProduto;
  final String nomeCliente;
  final int quantidadeProduto;
  final double faturamento;
  final Timestamp dataSaida;
  final String observacoes;

  Saida({
    required this.uid,
    required this.nomeProduto,
    required this.nomeCliente,
    required this.quantidadeProduto,
    required this.faturamento,
    required this.dataSaida,
    required this.observacoes,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uid': uid,
      'nomeProduto': nomeProduto,
      'nomeCliente': nomeCliente,
      'quantidadeProduto': quantidadeProduto,
      'faturamento': faturamento,
      'dataSaida': dataSaida,
      'observacoes': observacoes,
    };
  }

  factory Saida.fromJson(Map<String, dynamic> json) {
    return Saida(
      uid: json['uid'],
      nomeProduto: json['nomeProduto'],
      nomeCliente: json['nomeCliente'],
      quantidadeProduto: json['quantidadeProduto'],
      faturamento: json['faturamento'],
      dataSaida: json['dataSaida'],
      observacoes: json['observacoes'],
    );
  }
}
