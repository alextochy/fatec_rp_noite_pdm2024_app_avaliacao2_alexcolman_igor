import 'package:cloud_firestore/cloud_firestore.dart';

class Produto {
  final String uid;
  final String nomeProduto;
  final String descricaoProduto;
  final int quantidadeProduto;
  final double precoProduto;
  final String categoriaProduto;
  final Timestamp createdAt;

  Produto(
    this.uid,
    this.nomeProduto,
    this.descricaoProduto,
    this.quantidadeProduto,
    this.precoProduto,
    this.categoriaProduto,
    this.createdAt,
  );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uid': uid,
      'nomeProduto': nomeProduto,
      'descricaoProduto': descricaoProduto,
      'quantidadeProduto': quantidadeProduto,
      'precoProduto': precoProduto,
      'categoriaProduto': categoriaProduto,
      'createdAt': createdAt,
    };
  }

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      json['uid'],
      json['nomeProduto'],
      json['descricaoProduto'],
      json['quantidadeProduto'],
      json['precoProduto'],
      json['categoriaProduto'],
      json['createdAt'],
    );
  }
}
