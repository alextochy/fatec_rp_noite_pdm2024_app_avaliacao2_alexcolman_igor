import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/cliente.dart';
import '../view/util.dart';
import 'login_controller.dart';

class ClienteController {
  void adicionar(context, Cliente c) {
    FirebaseFirestore.instance
        .collection('clientes')
        .add(c.toJson())
        .then((resultado) =>
            sucesso(context, 'Cliente adicionado(a) com sucesso'))
        .catchError(
            (e) => erro(context, 'Não foi possível adicionar o(a) cliente'))
        .whenComplete(() => Navigator.pop(context));
  }

  // Listar todas as clientes do Usuário autenticado, ordenando por nomeCliente
  listar() {
    return FirebaseFirestore.instance
        .collection('clientes')
        .where('uid', isEqualTo: LoginController().idUsuario())
        .orderBy('nomeCliente', descending: false);
  }

  void atualizar(context, id, Cliente c) {
    FirebaseFirestore.instance
        .collection('clientes')
        .doc(id)
        .update(c.toJson())
        .then((resultado) =>
            sucesso(context, 'Cliente atualizado(a) com sucesso'))
        .catchError(
            (e) => erro(context, 'Não foi possível atualizar o(a) cliente'))
        .whenComplete(() => Navigator.pop(context));
  }

  void excluir(context, id) {
    FirebaseFirestore.instance
        .collection('clientes')
        .doc(id)
        .delete()
        .then(
            (resultado) => sucesso(context, 'Cliente excluído(a) com sucesso'))
        .catchError(
            (e) => erro(context, 'Não foi possível excluir o(a) cliente'));
  }
}
