import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/produto.dart';
import '../view/util.dart';
import 'login_controller.dart';

class ProdutoController {
  void adicionar(context, Produto p) {
    FirebaseFirestore.instance
        .collection('produtos')
        .add(p.toJson())
        .then((resultado) =>
            sucesso(context, 'Produto adicionado(a) com sucesso'))
        .catchError(
            (e) => erro(context, 'Não foi possível adicionar o(a) produto'))
        .whenComplete(() => Navigator.pop(context));
  }

  listar() {
    return FirebaseFirestore.instance
        .collection('produtos')
        .where('uid', isEqualTo: LoginController().idUsuario());
  }

  void atualizar(context, id, Produto p) {
    FirebaseFirestore.instance
        .collection('produtos')
        .doc(id)
        .update(p.toJson())
        .then((resultado) =>
            sucesso(context, 'Produto atualizado(a) com sucesso'))
        .catchError(
            (e) => erro(context, 'Não foi possível atualizar o(a) produto'))
        .whenComplete(() => Navigator.pop(context));
  }

  void excluir(context, id) {
    FirebaseFirestore.instance
        .collection('produtos')
        .doc(id)
        .delete()
        .then(
            (resultado) => sucesso(context, 'Produto excluído(a) com sucesso'))
        .catchError(
            (e) => erro(context, 'Não foi possível excluir o(a) produto'));
  }
}
