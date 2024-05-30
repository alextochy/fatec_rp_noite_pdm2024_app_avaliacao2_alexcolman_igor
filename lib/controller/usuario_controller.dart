import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/usuario.dart';
import '../view/util.dart';

class UsuarioController {
  void adicionar(context, Usuario u) {
    FirebaseFirestore.instance
        .collection('usuarios')
        .add(u.toJson())
        .then((resultado) => sucesso(context, 'Usuario adicionado com sucesso'))
        .catchError(
            (e) => erro(context, 'Não foi possível adicionar o usuario'))
        .whenComplete(() => Navigator.pop(context));
  }
}
