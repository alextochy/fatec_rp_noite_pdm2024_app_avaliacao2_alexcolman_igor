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
}
