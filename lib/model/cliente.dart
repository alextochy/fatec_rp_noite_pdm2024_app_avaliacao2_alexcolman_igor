import 'package:cloud_firestore/cloud_firestore.dart';

class Cliente {
  // Campos do documento
  final String uid;
  final String nomeCliente;
  final String cpfCliente;
  final String emailCliente;
  final String telefoneCliente;
  final Timestamp dataNascimentoCliente;
  final Timestamp? createdAt;

  Cliente(this.uid, this.nomeCliente, this.cpfCliente, this.emailCliente,
      this.telefoneCliente, this.dataNascimentoCliente,
      {this.createdAt});

  // Transforma um OBJETO em JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uid': uid,
      'nomeCliente': nomeCliente,
      'cpfCliente': cpfCliente,
      'emailCliente': emailCliente,
      'telefoneCliente': telefoneCliente,
      'dataNascimentoCliente': dataNascimentoCliente,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  // Transforma um JSON em OBJETO
  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      json['uid'],
      json['nomeCliente'],
      json['cpfCliente'],
      json['emailCliente'],
      json['telefoneCliente'],
      json['dataNascimentoCliente'],
      createdAt: json['createdAt'],
    );
  }
}
