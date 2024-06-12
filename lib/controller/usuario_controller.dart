import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/usuario.dart';
import '../view/util.dart';

class UsuarioController {
  //
  // ADICIONAR DADOS DO USUARIO
  // Adicionar os dados de um novo usuário na coleção
  // usuario
  //
  final _db = FirebaseFirestore.instance;

  void adicionar(context, Usuario u) {
    _db
        .collection('usuarios')
        .doc(u.uid)
        .set(u.toJson())
        .then((resultado) =>
            sucesso(context, 'Dados do usuário cadastrados com sucesso'))
        .catchError((e) =>
            erro(context, 'Não foi possível cadastrar os dados do usuário'))
        .whenComplete(() => Navigator.pop(context));
  }

  Future<Map<String, dynamic>?> obterDadosUsuario(String uid) async {
    try {
      // Obter os dados do usuário com o UID fornecido
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _db.collection('usuarios').doc(uid).get();
      if (snapshot.exists) {
        // Se o documento existir, retorna os dados
        return snapshot.data();
      } else {
        // Se o documento não existir, retorna nulo
        return null;
      }
    } catch (e) {
      // Em caso de erro, retorna nulo
      return null;
    }
  }

  // Atualizar os dados de um usuário existente na coleção 'usuarios'
  void atualizar(
      BuildContext context, String userId, Map<String, dynamic> novosDados) {
    _db
        .collection('usuarios')
        .doc(userId)
        .update(novosDados)
        .then(
            (_) => sucesso(context, 'Dados do usuário atualizados com sucesso'))
        .catchError((e) =>
            erro(context, 'Não foi possível atualizar os dados do usuário'));
  }
}
