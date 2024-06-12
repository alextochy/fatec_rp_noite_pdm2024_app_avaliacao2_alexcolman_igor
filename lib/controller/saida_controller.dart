import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/saida.dart';
import '../view/util.dart';
import 'login_controller.dart';

class SaidaController {
  void adicionar(context, Saida s) {
    FirebaseFirestore.instance
        .collection('saidas')
        .add(s.toJson())
        .then((resultado) => sucesso(context, 'Saída adicionada com sucesso'))
        .catchError((e) => erro(context, 'Não foi possível adicionar a saída'))
        .whenComplete(() => Navigator.pop(context));
  }

  listar() {
    return FirebaseFirestore.instance
        .collection('saidas')
        .where('uid', isEqualTo: LoginController().idUsuario());
  }

  void atualizar(context, id, Saida s) {
    FirebaseFirestore.instance
        .collection('saidas')
        .doc(id)
        .update(s.toJson())
        .then((resultado) => sucesso(context, 'Saída atualizada com sucesso'))
        .catchError((e) => erro(context, 'Não foi possível atualizar a saída'))
        .whenComplete(() => Navigator.pop(context));
  }

  void excluir(context, id) {
    FirebaseFirestore.instance
        .collection('saidas')
        .doc(id)
        .delete()
        .then((resultado) => sucesso(context, 'Saída excluída com sucesso'))
        .catchError((e) => erro(context, 'Não foi possível excluir a saída'));
  }

  Future<double> getPrecoProduto(String nomeProduto) async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('produtos')
        .where('nomeProduto', isEqualTo: nomeProduto)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first['precoProduto'];
    }
    throw Exception('Produto não encontrado');
  }
}
