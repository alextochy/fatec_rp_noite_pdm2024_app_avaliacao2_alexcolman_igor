// ignore_for_file: body_might_complete_normally_nullable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../view/util.dart';

class LoginController {
  //
  // CRIAR CONTA
  // Adiciona a conta de um novo usuário no serviço
  // Firebase Authentication
  //
  Future<User?> criarConta(context, nome, email, senha) async {
    if (nome.isEmpty) {
      erro(context, 'Por favor, insira seu nome.');
      return null;
    }
    if (nome.length < 3) {
      erro(context, 'O nome deve ter pelo menos 3 caracteres.');
      return null;
    }
    try {
      UserCredential resultado = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: senha);
      sucesso(context, 'Usuário criado com sucesso!');
      return resultado.user;
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            erro(context, 'O email já foi cadastrado.');
            break;
          default:
            erro(context, 'ERROR: ${e.code.toString()}');
        }
      } else {
        erro(context, 'Ocorreu um erro inesperado.');
      }
      return null;
    }
  }

  //
  // LOGIN
  //
  login(context, email, senha) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: senha)
        .then((resultado) {
      sucesso(context, 'Usuário autenticado com sucesso!');
      Navigator.pushNamed(context, 'principal');
    }).catchError((e) {
      switch (e.code) {
        case 'invalid-credential':
          erro(context, 'Email e/ou senha inválida');
          break;
        case 'invalid-email':
          erro(context, 'O formato do email é inválido.');
          break;
        default:
          erro(context, 'ERRO: ${e.code.toString()}');
      }
    });
  }

  //
  // ESQUECEU A SENHA
  //
  esqueceuSenha(context, String email) {
    if (email.isNotEmpty) {
      FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
      sucesso(context, 'Email enviado com sucesso!');
    } else {
      erro(context, 'Não foi possível enviar o e-mail');
    }
  }

  //
  // LOGOUT
  //
  logout() {
    FirebaseAuth.instance.signOut();
  }

  //
  // Usuário Logado
  //
  Future<String> usuarioLogado() async {
    var usuario = '';
    await FirebaseFirestore.instance
        .collection('usuarios')
        .where('uid', isEqualTo: idUsuario())
        .get()
        .then(
      (resultado) {
        usuario = resultado.docs[0].data()['nome'] ?? '';
      },
    );
    return usuario;
  }

  //
  // ID do Usuário Logado
  //
  idUsuario() {
    return FirebaseAuth.instance.currentUser!.uid;
  }
}
